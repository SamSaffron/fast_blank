require 'mkmf'

if ENV['VERSION'] != "C" && find_executable('crystal') && find_executable('llvm-config')
  # Very dirty patching
  def create_makefile(target, srcprefix = nil)
    mfile = open("Makefile", "wb")
    cr_makefile = File.join(File.dirname(__FILE__), "../src/Makefile")
    mfile.print File.read(cr_makefile)
  ensure
    mfile.close if mfile
    puts "Crystal version of the Makefile copied"
  end
end

create_makefile 'fast_blank'
