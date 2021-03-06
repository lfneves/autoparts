# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Commands
    class Search
      def initialize(args, options)
        begin
          Pathname.new("#{PROJECT_ROOT}/lib/autoparts/packages").children.sort.each do |f|
            require "autoparts/packages/#{f.basename.sub_ext('')}" if f.extname == '.rb'
          end
        rescue LoadError
        end
        packages = Package.packages
        if args.length > 0
          packages = packages.select { |name, _| name.include? args[0] }
        end
        if packages.length > 0
          list = {}
          packages.each_pair do |name, package_class|
            package = package_class.new
            list["#{name} (#{package.version})"] = package.description
          end
          unless list.empty?
            ljust_length = list.keys.map(&:length).max + 1
            list.each_pair do |name, description|
              print name.ljust(ljust_length)
              print description if description
              puts
            end
          end
        else
          abort "parts: no package found for \"#{args[0]}\""
        end
      end
    end
  end
end
