#!/usr/bin/env ruby
require 'fileutils'

def get_pid_children(target_pid)
  list = IO.popen("pgrep --parent=#{target_pid}").readlines
  list.map! { |line| line.chomp.to_i }
  list
end

def kill_strace(strace_pid)
  strace_children_pids = get_pid_children(strace_pid)
  strace_children_pids.each do |pid|
    Process.kill("TERM", pid)
  end
  Process.waitpid(strace_pid)
end

def iterate_on(name, seconds, *argv)
  sink_pid = spawn "./start-test-server.sh"
  sleep 1
  subject_pid = spawn "./strace-run.sh", name, *argv
  sleep 1
  system "./dstatctl.sh", "start", name
  sleep 5 # warmup
  source_pid = spawn "./send-test-data.sh", seconds

  Process.wait source_pid
  puts "Source terminated"

ensure
  sleep 1
  puts "Terminating the rest"

  system "./dstatctl.sh", "stop" rescue nil

  kill_strace subject_pid

  Process.kill("TERM", sink_pid)
  Process.waitpid sink_pid

  FileUtils.cp "/tmp/tcp_test_server_summary.json", "tcp_test_server_summary-#{name}.json"

  puts "Ensuring everything is stopped"
  p Process.waitall
end

seconds = ARGV.first || "10"

iterate_on "tokio-01-check", seconds, "target/debug/tokio-01-check"
iterate_on "tokio-compat-check", seconds, "target/debug/tokio-compat-check"
iterate_on "tokio-02-check", seconds, "target/debug/tokio-02-check"
iterate_on "vector-tokio-01", seconds, "../vector-tokio-compat-base/target/debug/vector", "-c", "vector.toml"
iterate_on "vector-tokio-compat", seconds, "../vector/target/debug/vector", "-c", "vector.toml"
