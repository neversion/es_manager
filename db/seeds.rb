require "#{Rails.root}/db/oai_import.rb"
require 'benchmark'

#create_index_mapping "oai_ik_stem_all"
puts Benchmark.measure{ import_oai_test_data "oai_ik_stem_all","/hd/metadata/data/apabi" }
