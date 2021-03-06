#!/usr/bin/env ruby

# frozen_string_literal: true

require 'json'

# Variable interpolation via Bazel template expansion.
helm = '[[helm]]'
install_name = '[[install_name]]'
chart_package = '[[chart_package]]'
namespace = '[[namespace]]'
install = '[[install]]' == 'True'
reset_values = '[[reset_values]]' == 'True'
values_paths = '[[values_paths]]'
path_split_delim = '[[path_split_delim]]'
set_values = JSON.parse('[[set_values]]')

args = [
  helm, 'upgrade', install_name, chart_package,
  '--namespace', namespace
]

args.push('--install') if install
args.push('--reset-values') if reset_values

values = values_paths.split(path_split_delim).map do |path|
  ['--values', path]
end
args.concat(*values)

set_values = set_values.map do |key, value|
  ['--set', "#{key}=#{value}"]
end
args.concat(*set_values)

puts "CMD #{args}"

exit Process.wait2(Process.spawn(*args)).last.exitstatus
