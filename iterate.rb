#!/usr/bin/env ruby

def iterate_on(what)
  sink_pid = spawn "./start-test-server.sh"
  sleep 1
  subject_pid = spawn "./strace-run.sh", what
  sleep 1
  system "./dstatctl.sh", "start", what
  sleep 1
  source_pid = spawn "./send-test-data.sh"

  Process.wait source_pid
  puts "Source terminated"

  sleep 1
  puts "Terminating the rest"

  system "./dstatctl.sh", "stop"
  system "pkill", "-f", what
  Process.kill("TERM", sink_pid)

  sleep 1
end

iterate_on "tokio-01-check"
iterate_on "tokio-compat-check"
iterate_on "tokio-02-check"
