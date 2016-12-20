require 'etc'

Susu.refine binding

module Susu
module Fs

class TestPath < Test::Unit::TestCase

def self.startup

	@@tmpdir  = Dir.mktmpdir( [ '', self.lastname ] ).path

end


def self.shutdown

	@@tmpdir.rm_secure

end


def setup

	@@pwd = Dir.pwd
	@@tmp = @@tmpdir.path.mkdir method_name

end


def teardown

	Dir.chdir @@pwd
	@@tmp.rm_secure

end


def test00Constructor

	f = Path.new '.'

	assert_instance_of( Path, f      )
	assert            ( f.exist?     )
	assert            ( f.directory? )

end


def test01fromString

	f = ( @@tmp + '/doesnotexist' ).path

	assert_instance_of( Path, f        )
	assert            ( ! f.exist?     )
	assert            ( ! f.directory? )

end


def test02Mkdir

	tmp = @@tmp.path

	assert_instance_of( Path, tmp      )
	assert            ( tmp.exist?     )
	assert            ( tmp.directory? )

	d = tmp.mkdir 'some'

	assert_instance_of( Path, d )

	assert_equal( @@tmp.to_path + '/some', d.to_path )
	assert      ( d.exist?     )
	assert      ( d.directory? )

	# If the path exists and it is a directory, do nothing.
	#
	d = tmp.mkdir 'd'
	f = d  .touch 'f'

	d.mkdir
	assert_equal tmp + 'd', d
	assert       d.directory?
	assert       f.file?

	# If self is a file, make dir in directory of file.
	#
	f = tmp.touch 'ff'

	d = f.mkdir 'ho'
	assert_equal tmp + 'ho', d
	assert       f.file?

	# If target is a file, raise.
	#
	f = tmp.touch 'fff'

	assert_raise { d = tmp.mkdir 'fff' }

	assert       f.file?

	# TODO: absolute paths
	# TODO: path objects instead of strings

end


def test03Mkpath

	path = @@tmp + 'some'
	f = path.mkpath

	assert_instance_of( Path, f      )
	assert            ( f.exist?     )
	assert            ( f.directory? )

end


def test04MkpathSub

	f = @@tmp

	assert_instance_of( Path, f      )
	assert            ( f.exist?     )
	assert            ( f.directory? )

	d = f.mkpath 'some/other'

	assert_instance_of( Path, d )

	assert_equal( @@tmp.to_path + '/some/other', d.to_path )
	assert      ( d.exist?     )
	assert      ( d.directory? )

end


def test04Glob

	f = @@tmp.path

	assert_instance_of( Path, f      )
	assert            ( f.exist?     )
	assert            ( f.directory? )

	f.touch 'haha'
	f.touch 'hihi'

	d = f.glob( '*' )

	assert_instance_of( Array, d        )
	assert_equal(       2    , d.length )

	assert( d.all? { |p| p.kind_of? Path } )

end


# TODO: verify follow and withDir options
#
def test05Children

	p = @@tmp
	sub = p.mkdir 'sub'

	assert_instance_of( Path, p        )
	assert_instance_of( Path, sub      )
	assert            ( p  .directory? )
	assert            ( sub.directory? )

	# Include a hidden entry
	#
	haha = p.touch '.haha'
	hihi = p.touch 'hihi'

	ssub = sub .mkdir 'ssub'
	hoho = sub .touch 'hoho'
	hehe = ssub.touch 'hehe'

	aP    = [ haha, hihi, sub ]
	aSub  = [ hoho, ssub      ]
	aSsub = [ hehe            ]

	cP    = p   .children( recurse: false )
	cSub  = sub .children( recurse: false )
	cSsub = ssub.children( recurse: false )

	assert_equal  aP   , cP   .sort
	assert_equal  aSub , cSub .sort
	assert_equal  aSsub, cSsub.sort

	assert        cP   .all? { |e| e.kind_of? Path }
	assert        cSub .all? { |e| e.kind_of? Path }
	assert        cSsub.all? { |e| e.kind_of? Path }

	# recursive

	arSsub = aSsub
	arSub  = aSub  + aSsub
	arP    = aP    + aSub  + aSsub

	crP    = p   .children
	crSub  = sub .children
	crSsub = ssub.children

	assert_equal  arP   , crP   .sort
	assert_equal  arSub , crSub .sort
	assert_equal  arSsub, crSsub.sort

	assert        crP   .all? { |e| e.kind_of? Path }
	assert        crSub .all? { |e| e.kind_of? Path }
	assert        crSsub.all? { |e| e.kind_of? Path }

end



def test06Pwd

	Dir.chdir '/home'
	path = Path.pwd

	assert_instance_of Path        , path
	assert_equal       '/home'.path, path

	# Reover form unexisting pwd
	#
	Dir.mktmpdir do |dir|

		Dir.chdir dir

	end

	path = Path.pwd

	assert_instance_of Path         , path
	assert_equal       Dir.home.path, path

end



def test07Cd

	path = Path.cd '/home'

	assert_instance_of Path        , path
	assert_equal       '/home'.path, Dir.pwd.path

end



def test08PushdPopd

	orig = Path.pwd

	path = Path.pushd '/home'

	assert_instance_of Path        , path
	assert_equal       '/home'.path, Dir.pwd.path

	assert_equal orig, Path.popd


	# Change the working dir in another way
	#
	orig = Path.cd '/'

	path1 = Path.pushd '/home'
	path2 = Path.cd    '/var'
	path3 = Path.pushd '/usr'

	assert_instance_of Path , orig
	assert_instance_of Path , path1
	assert_instance_of Path , path2
	assert_instance_of Path , path3

	assert_equal       path2, Path.popd
	assert_equal       orig , Path.popd

end



def test09Hidden?

	p = @@tmp

	hoho = p.mkdir 'hoho'
	hehe = p.mkdir '.hehe'
	hihi = p.touch 'hihi'
	haha = p.touch '.haha'

	assert_equal  false, hoho.hidden?
	assert_equal  false, hihi.hidden?
	assert_equal  true , hehe.hidden?
	assert_equal  true , haha.hidden?

end



def test10Ls

	p = @@tmp
	sub = p.mkdir 'sub'

	assert_instance_of( Path, p        )
	assert_instance_of( Path, sub      )
	assert            ( p  .directory? )
	assert            ( sub.directory? )

	# Include a hidden entry
	#
	hihi = p  .touch 'hihi'

	p  .touch '.haha'
	sub.touch 'hoho'

	assert_equal  [ hihi, sub ], p.ls.sort

end



def test11La

	p = @@tmp
	sub = p.mkdir 'sub'

	assert_instance_of( Path, p        )
	assert_instance_of( Path, sub      )
	assert            ( p  .directory? )
	assert            ( sub.directory? )

	# Include a hidden entry
	#
	haha = p  .touch '.haha'
	hihi = p  .touch 'hihi'

	sub.touch 'hoho'

	assert_equal  [ haha, hihi, sub ], p.la.sort

end



def test12Io

	p    = @@tmp
	haha = p.touch( 'haha' ).io

		assert_instance_of File, haha

		assert_raise( Errno::EISDIR ) { p.io }

end



def test13Empty?

	p    = @@tmp
	haha = p.touch( 'haha' )
	hoho = p.touch( 'hoho' )
	hoho.write "hehe"

		assert haha.empty?

		assert_false p.empty?
		assert_false hoho.empty?


	haha.rm
	hoho.rm

		assert p.empty?


		assert_nil 'doesnotexist'.path.empty?

end



def test14Empty

	p    = @@tmp
	hoho = p.touch( 'hoho' )
	hoho.write "hehe"

		assert_false p.empty?
		assert_false hoho.empty?


	hoho.empty

		assert hoho.empty?


	p.empty

		assert p.empty?

end



def test15Content

	p    = @@tmp
	haha = p.touch( 'haha' )
	hoho = p.touch( 'hoho' )
	hoho.write "hehe"

		assert_equal [ haha, hoho ], p.content
		assert_equal ""            , haha.content
		assert_equal "hehe"        , hoho.content
		assert_nil   'doesnotexist'.path.empty?

end




end # class  TestPath
end # module Fs
end # module Susu
