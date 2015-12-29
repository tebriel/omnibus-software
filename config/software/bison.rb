name "bison"
default_version "3.0"

relative_path "bison-3.0"

source :url => "http://ftp.gnu.org/gnu/bison/bison-3.0.tar.gz",
       :md5 => "977106b703c7daa39c40b1ffb9347f58"

env = with_standard_compiler_flags()

build do
  command "./configure --prefix=#{install_dir}/embedded", :env => env
  command "make -j #{workers}", :env => env
  command "make -j #{workers} install", :env => env
end
