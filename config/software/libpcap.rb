#
# Copyright:: Copyright (c) 2012-2014 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "libpcap"
default_version "1.7.4"

version "1.7.4" do
  source md5: "b2e13142bbaba857ab1c6894aedaf547"
end

source url: "http://www.tcpdump.org/release/libpcap-#{version}.tar.gz"

relative_path "libpcap-#{version}"

dependency "flex"

# we omit the omnibus path here because it breaks mac_os_x builds by picking up the embedded libtool
# instead of the system libtool which the zlib configure script cannot handle.
#env = with_embedded_path()
env = with_standard_compiler_flags()

build do
  ship_license "https://gist.githubusercontent.com/truthbk/b06f2ea54f6f297c599e/raw/e1fc035d3114cd43e55fabcddd073e20307c129e/libpcap.license"
  command "./configure --prefix=#{install_dir}/embedded", :env => env
  command "make -j #{workers}", :env => env
  command "make -j #{workers} install", :env => env
end
