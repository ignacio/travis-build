# Community maintainers:
#
#   Ignacio Burgueño
#   iburgueno@gmail.com
#   https://github.com/ignacio
#
module Travis
  module Build
    class Script
      class Lua < Script
        DEFAULTS = {
          lua: '5.3.0'
        }

        def configure
          super

          case config[:os]
          when 'linux'
            #sh.cmd 'sudo apt-get update -qq', retry: true
            #sh.cmd 'sudo apt-get install libgc1c2 -qq', retry: true # required by neko
          when 'osx'
            # pass
          end
        end

        def export
          super

          sh.export 'TRAVIS_LUA_VERSION', config[:lua].to_s, echo: false
        end

        def setup
          super

          sh.echo 'Lua for Travis-CI is not officially supported, ' \
                  'but is community maintained.', ansi: :green
          sh.echo 'Please file any issues using the following link',
                  ansi: :green
          sh.echo '  https://github.com/travis-ci/travis-ci/issues' \
                  '/new?labels=lua', ansi: :green
          sh.echo 'and mention \`@ignacio\`'\
                  ' in the issue', ansi: :green

          sh.fold('lua-install') do
            sh.echo 'Installing Lua', ansi: :yellow
            sh.cmd 'mkdir -p ~/lua'
            sh.cmd %Q{curl -s -L --retry 3 '#{lua_url}' } \
                   '| tar -C ~/lua -x -z --strip-components=1 -f -'
            sh.cmd 'cd ~/lua && make linux && make INSTALL_TOP=~/lua install'
            ln -s ~/lua/bin/lua $HOME/.lua/lua;
            ln -s ~/lua/bin/luac $HOME/.lua/luac;
            sh.cmd 'export PATH="${PATH}:${HOME}/haxe"'
          end
        end

        def announce
          super

          # Neko 2.0.0 output the version number without linebreak.
          # The webpage has trouble displaying it without wrapping with echo.
          sh.cmd "lua -v"
        end

        def install
          
        end

        def script
          
        end

        private

          def lua_url
            case config[:lua]
            when '5.3.0'
              "http://www.lua.org/ftp/lua-5.3.0.tar.gz"
            when '5.2.4'
              "http://www.lua.org/ftp/lua-5.2.4.tar.gz"
            when '5.1.5'
              "http://www.lua.org/ftp/lua-5.1.5.tar.gz"
            when 'luajit2.0'
              "http://luajit.org/download/LuaJIT-2.0.3.tar.gz"
            else
              os = case config[:os]
              when 'linux'
                'linux64'
              when 'osx'
                'osx'
              end
              version = config[:haxe].to_s
              "http://haxe.org/website-content/downloads/#{version.gsub('.',',')}/downloads/haxe-#{version}-#{os}.tar.gz"
            end
          end

      end
    end
  end
end
