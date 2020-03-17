# テストするファイルの指定　Railsではすべて自動でrequireされている
# require_relative '../lib/hello'

# require するのも、アプリケーションのコードなので、spec_helper.rb で一括指定したほうがいいということで変更
require 'spec_helper'

RSpec.describe Hello do
    # it はテストを example という単位にまとめる役割
    # expect(X).to eq Y は「XがYに等しくなることを期待する
  it "message return hello" do
    expect(Hello.new.message).to eq "hello"
  end
end