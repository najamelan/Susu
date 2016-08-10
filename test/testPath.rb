require 'etc'

module TidBits
module Fs

class TestPath < Test::Unit::TestCase


def self.startup

	@@user = Etc.getpwuid( Process.euid )
	@@tmpd = FileUtils.mkpath( "/run/shm/#{ @@user.uid }/tidbits/fs/#{randomString}/" ).first

end


def self.shutdown

	FileUtils.remove_entry_secure @@tmpd

end



def self.randomString

	rand( 36**8 ).to_s( 36 )

end



def setup

	@@tmp = File.join @@tmpd, method_name

end



def test00Constructor

	f = Path.new '.'

	assert_instance_of( Path, f      )
	assert            ( f.exist?     )
	assert            ( f.directory? )

end


def test01fromString

	f = @@tmp.path

	assert_instance_of( Path, f        )
	assert            ( ! f.exist?     )
	assert            ( ! f.directory? )

end


def test02Mkdir

	FileUtils.mkpath @@tmp

	tmp = @@tmp.path

	assert_instance_of( Path, tmp      )
	assert            ( tmp.exist?     )
	assert            ( tmp.directory? )

	d = tmp.mkdir 'some'

	assert_instance_of( Path, d )

	assert_equal( @@tmp + '/some', d.to_path )
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

	path = @@tmp + '/some'
	f = path.path.mkpath

	assert_instance_of( Path, f      )
	assert            ( f.exist?     )
	assert            ( f.directory? )

end


def test04MkpathSub

	FileUtils.mkpath @@tmp

	f = @@tmp.path

	assert_instance_of( Path, f      )
	assert            ( f.exist?     )
	assert            ( f.directory? )

	d = f.mkpath 'some/other'

	assert_instance_of( Path, d )

	assert_equal( @@tmp + '/some/other', d.to_path )
	assert      ( d.exist?     )
	assert      ( d.directory? )

end


def test04Glob

	FileUtils.mkpath @@tmp

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

	p = @@tmp.path.mkpath
	sub = p.mkdir 'sub'

	assert_instance_of( Path, p        )
	assert_instance_of( Path, sub      )
	assert            ( p  .directory? )
	assert            ( sub.directory? )

	haha = p.touch 'haha'
	hihi = p.touch 'hihi'

	ssub = sub .mkdir 'ssub'
	hoho = sub .touch 'hoho'
	hehe = ssub.touch 'hehe'

	aP    = [ hihi, haha, sub ]
	aSub  = [ hoho, ssub      ]
	aSsub = [ hehe            ]

	cP    = p   .children
	cSub  = sub .children
	cSsub = ssub.children

	assert_instance_of( Array, cP )
	assert_equal(       aP   , cP )
	assert( cP.all? { |e| e.kind_of? Path } )

	assert_instance_of( Array, cSub )
	assert_equal(       cSub, aSub )
	assert( cSub.all? { |e| e.kind_of? Path } )

	assert_instance_of( Array, cSsub )
	assert_equal(       cSsub, aSsub )
	assert( cSsub.all? { |e| e.kind_of? Path } )

	# recursive

	arSsub = aSsub
	arSub  = aSub  + aSsub
	arP    = aP    + aSub  + aSsub

	crP    = p   .children( recursive: true )
	crSub  = sub .children( recursive: true )
	crSsub = ssub.children( recursive: true )

	assert_instance_of( Array, crP )
	assert_equal(       arP   , crP )
	assert( crP.all? { |e| e.kind_of? Path } )

	assert_instance_of( Array, crSub )
	assert_equal(       crSub, arSub )
	assert( crSub.all? { |e| e.kind_of? Path } )

	assert_instance_of( Array, crSsub )
	assert_equal(       crSsub, arSsub )
	assert( crSsub.all? { |e| e.kind_of? Path } )

end




end # class  TestPath
end # module Fs
end # module TidBits
