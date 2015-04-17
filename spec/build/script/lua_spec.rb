require 'spec_helper'

describe Travis::Build::Script::Lua, :sexp do
  let(:data)   { payload_for(:push, :lua) }
  let(:script) { described_class.new(data) }
  subject      { script.sexp }

  it_behaves_like 'a build script sexp'

  it 'downloads and installs lua' do
    should include_sexp [:cmd, %r(curl .*lua.*\.tar\.gz),
                         assert: true, echo: true, timing: true]
  end

  it 'announces lua version' do
    should include_sexp [:cmd, /lua -v/, echo: true]
  end
end
