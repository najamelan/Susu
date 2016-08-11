# TidBits_Ruby_Facts
Declarative OOP facts for tracking and fixing states 


## Dependencies

### Facts

- depend on another fact by calling `dependOn` in the constructor or by passing `dependOn` option to constructor. All conditions of the dependency must pass before any conditions of the depending fact will be called. If a dependency fails, the fact fails.

- For obligatory options, make them named parameters of the constructor without default value.

- If you want to warn a user for potentially calling a condition without specifying all the information it needs you need to do that in the fact, because conditions only fail when they really have to. The example below shows how path `:exist` would pass fix even without `:type` being set as long as the path already exists. Maybe you want to warn the user that it's not a good idea to call fix on `:exist` true if they didn't set type, because that would fail if the path needs to be created. You can do that easily in your fact by overriding Fact#fix:

         def fix

            options.exist == true && !options.has_key?( :type ) and

               raise ArgumentError.new 'message'

            super

         end
         

### Conditions

Conditions have a method called `dependOn` as well, it returns a boolean and if it returns false, you should abort the operation. For conditions, you can have last minute dependencies, in contrast to facts. For facts, dependencies are specified in the constructor and always run before the fact itself calls it's own conditions. Within a condition you can have dependencies last minute, which allow all other operations to succeed. Eg. to create a path we need to know which type it must be (file, directory, ...) but not to remove it. So exist false can be fixed without having type set in the options, but exist true can't. However, exist true can be analyzed and checked and if it exists fix will never have to do anything, so if the user doesn't specify the type, everything works even calling fix as long as we don't need to create the path. This allows flexible dependency management, blocking only when we really have to. To warn the user about a potential error, see above in the facts section how you can do that.

- To require that a different option is set on the fact, just do (in analyze, check or fix):

         # This is the code for TidBits::Fs::Facts::Path::Conditions::Exist
         # 
         def fix

            super do

               if @expect # The path must exist

                  options.has_key?( :type ) or 

                     raise ArgumentError.new "Path::Conditions::Exist cannot create a path without knowing whether it should be a file, directory, ..."

                  # or if you don't want to raise and exception, you can also abord the operation 
                  # (after a fix block has finished, superclass will call check to determine whether it passed or failed):
                  # 
                  options.has_key?( :type ) or break

                  options.type == :file       and  options.path.touch
                  options.type == :directory  and  options.path.mkdir
                  ...

               else # The path shouldn't exist

                  options.path.rm_secure

               end

            end


- To depend on a condition of the same fact:

         # Git::Repo::Clean#analyze depends on the repo to be not bare in order to analyze whether the working dir is clean.
         # The condition will be created and added to the fact if it does not exist.
         # 
         def analyze

            super do

               dependOn( :bare, false, options ) or break analyzeFailed
               @repo.clean?

            end

         end
         
         # Now if the user has done this, analyze will fail:
         # 
         TidBits::Git::Facts::Repo.new( path: someDir, clean: true, bare: true )


- To depend on a condition of another fact (in analyze, check or fix):
   
         # Imagine for a specific condition, a certain path must be a directory. 
         #
         dependOnFact( TidBits::Fs::Facts::Path, path: someDir, type: directory ) or break checkFailed

         # Now the fact will be added to the statemachine, will be checked and if it fails
         # and we are currently fixing (if the user calls analyze or check no changes to the system will be made)
         # fix will be called on the fact before continuing. If the dependency fails, xxxFailed will be called for the 
         # depending condition on whether we are analyzing, checking or fixing and false will be returned from dependOn.   

   
