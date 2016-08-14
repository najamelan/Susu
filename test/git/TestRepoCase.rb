require 'securerandom'
require 'open3'

require_relative '../../facts/test/TestFactCase'


module Susu
module Git

class TestRepoCase < Susu::Facts::TestFactCase



def setup

	super

	@@repo    = 'data/fixtures/clean'.relpath.copy @@tmpdir
	@@repo[ '.gitted' ].rename '.git'

end



def randomString

	SecureRandom.uuid[0...8]

end



def pollute path

	out = []

	out += cmd "touch   polluteWorkingDir" , path
	out += cmd "touch   polluteIndex"      , path
	out += cmd "git add polluteIndex"      , path

	return out

end



def commitOne path

	file, out = pollute path

	out += cmd "git commit -am'commit #{file}'", path

	return file, out

end



def clone path

	tmp  = tmpDir
	name = randomString
	out  = []

	out += cmd "git clone #{path} #{name}", tmp

	return "#{tmp}/#{name}", out

end



# Run a system command or a sequence of commands
#
# @param cmd [string|Array<string>] The command(s) to run.
#
# options: hash
#   clearing environment variables:
#     :unsetenv_others => true   : clear environment variables except specified by env
#     :unsetenv_others => false  : don't clear (default)
#   process group:
#     :pgroup => true or 0 : make a new process group
#     :pgroup => pgid      : join to specified process group
#     :pgroup => nil       : don't change the process group (default)
#   create new process group: Windows only
#     :new_pgroup => true  : the new process is the root process of a new process group
#     :new_pgroup => false : don't create a new process group (default)
#   resource limit: resourcename is core, cpu, data, etc.  See Process.setrlimit.
#     :rlimit_resourcename => limit
#     :rlimit_resourcename => [cur_limit, max_limit]
#   umask:
#     :umask => int
#   redirection:
#     key:
#       FD              : single file descriptor in child process
#       [FD, FD, ...]   : multiple file descriptor in child process
#     value:
#       FD                        : redirect to the file descriptor in parent process
#       string                    : redirect to file with open(string, "r" or "w")
#       [string]                  : redirect to file with open(string, File::RDONLY)
#       [string, open_mode]       : redirect to file with open(string, open_mode, 0644)
#       [string, open_mode, perm] : redirect to file with open(string, open_mode, perm)
#       [:child, FD]              : redirect to the redirected file descriptor
#       :close                    : close the file descriptor in child process
#     FD is one of follows
#       :in     : the file descriptor 0 which is the standard input
#       :out    : the file descriptor 1 which is the standard output
#       :err    : the file descriptor 2 which is the standard error
#       integer : the file descriptor of specified the integer
#       io      : the file descriptor specified as io.fileno
#   file descriptor inheritance: close non-redirected non-standard fds (3, 4, 5, ...) or not
#     :close_others => true  : don't inherit
#   current directory:
#     :chdir => str
#
def cmd cmds, cwd = Fs::Path.pwd, **options

	pwd = Fs::Path.pwd

	Fs::Path.chdir cwd

	output = []
	cmds   = Array.eat cmds

	cmds.each do |cmd|

		stdout, stderr, status = Open3.capture3( cmd, options )

		output << { cmd: cmd, cwd: cwd.to_path, options: options, stdout: stdout, stderr: stderr, status: status }

	end

	return output

ensure

	Fs::Path.chdir pwd

end


end # class  TestRepoCase
end # module Git
end # module Susu
