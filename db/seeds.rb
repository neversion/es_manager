require "#{Rails.root}/db/oai_import.rb"
require 'benchmark'

#create_index_mapping "oai_all"
#puts Benchmark.measure{ import_oai_test_data "oai_ik_stem_all","/hd/metadata/data/apabi" }
#puts Benchmark.measure{ import_bulk "oai_ik_stem_all_bulk","/hd/metadata/data/asia" }
puts Benchmark.measure{ import_bulk "oai_all","/oai_metadata/data/opac" }
