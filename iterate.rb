#!/usr/bin/env ruby
require 'fileutils'

def iterate_on(what, seconds)
  sink_pid = spawn "./start-test-server.sh"
  sleep 1
  subject_pid = spawn "./strace-run.sh", what
  sleep 1
  system "./dstatctl.sh", "start", what
  sleep 1
  source_pid = spawn "./send-test-data.sh", seconds

  Process.wait source_pid
  puts "Source terminated"

  sleep 1
  puts "Terminating the rest"

  system "./dstatctl.sh", "stop"
  system "pkill", "-f", what
  Process.kill("TERM", sink_pid)

  Process.wait sink_pid rescue nil
  FileUtils.cp "/tmp/tcp_test_server_summary.json", "tcp_test_server_summary-#{what}.json"

  sleep 1
end

seconds = ARGV.first || "10"

iterate_on "tokio-01-check", seconds
iterate_on "tokio-compat-check", seconds
iterate_on "tokio-02-check", seconds
