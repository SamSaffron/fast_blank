require 'mkmf'

if ENV['C'].nil? && find_executable('crystal') && find_executable('llvm-config')
  # Dirty patching
  def create_makefile(_, _ = nil)
    cr_makefile = File.join(File.dirname(__FILE__), "../src/Makefile")
    makefile    = File.join(File.dirname(__FILE__), "../Makefile")
    FileUtils.rm_rf(makefile)
    FileUtils.cp(cr_makefile, makefile)
    puts "Crystal version of the Makefile copied"
  end
end

create_makefile 'fast_blank'
