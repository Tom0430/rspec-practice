# テストするファイルの指定　Railsではすべて自動でrequireされている
# require_relative '../lib/hello'

# require するのも、アプリケーションのコードなので、spec_helper.rb で一括指定したほうがいいということで変更
require 'spec_helper'

RSpec.describe Hello do
    # it はテストを example という単位にまとめる役割
    # expect(X).to eq Y は「XがYに等しくなることを期待する」
  it "message return hello" do
    expect(Hello.new.message).to eq "hello"
  end
end


# 原則として1つの example につき1つのエクスペクテーションで書いた方がテストの保守性が良くなる
# 途中でテストが失敗したときに、その先のエクスペクテーションがパスするのかしないのかが予想できないから
# RSpec.describe '四則演算' do
#     it '全部できること' do
#       expect(1 + 2).to eq 3
#       expect(10 - 1).to eq 9
#       expect(4 * 8).to eq 32
#       expect(40 / 5).to eq 8
#     end
# end

# ネストさせることもできる　一番外側以外は　Rspec.　を省略可能
# RSpec.describe '四則演算' do
#     describe '足し算' do
#       it '1 + 1 は 2 になること' do
#         expect(1 + 1).to eq 2
#       end
#     end
#     describe '引き算' do
#       it '10 - 1 は 9 になること' do
#         expect(10 - 1).to eq 9
#       end
#     end
# end

# # RSpec.describe UserのUserはクラス名
# RSpec.describe User do
#     # Userクラスのインスタンスメソッドgreetを使いますよということでわかりやすくこう書いている
#     describe '#greet' do
#         # discribeと同じようにcontextも使える、context は条件を分けたりするときに使うことが多い
#         context '12歳以下の場合' do
#             it 'ひらがなで答えること' do
#             user = User.new(name: 'たろう', age: 12)
#             expect(user.greet).to eq 'ぼくはたろうだよ。'
#             end
#         end
#         context '13歳以上の場合' do
#             it '漢字で答えること' do
#               user = User.new(name: 'たろう', age: 13)
#               expect(user.greet).to eq '僕はたろうです。'
#             end
#         end
#     end
# end

# 上のコードを変更
# RSpec.describe User do
#     describe '#greet' do
#         # beforeはexampleの前に必ず読み込まれる　たろうが重複するのでまとめる
#         before do
#             @params = { name: 'たろう' }
#         end
#         context '12歳以下の場合' do
#             it 'ひらがなで答えること' do
#             user = User.new(@params.merge(age: 12))
#             expect(user.greet).to eq 'ぼくはたろうだよ。'
#             end
#         end
#         context '13歳以上の場合' do
#             it '漢字で答えること' do
#             user = User.new(@params.merge(age: 13))
#             expect(user.greet).to eq '僕はたろうです。'
#             end
#         end
#     end
# end

# さらに変更　ネストした
# RSpec.describe User do
#     describe '#greet' do
#     # 親のbefore~endが子のcontextでも先に毎回呼ばれる
#         before do
#             @params = { name: 'たろう' }
#         end
#         context '12歳以下の場合' do
#             before do
#                 params.merge!(age: 12)
#             end
#             it 'ひらがなで答えること' do
#                 user = User.new(params)
#                 expect(user.greet).to eq 'ぼくはたろうだよ。'
#             end
#         end
#         context '13歳以上の場合' do
#             before do
#                 params.merge!(age: 13)
#             end
#             it '漢字で答えること' do
#                 user = User.new(params)
#                 expect(user.greet).to eq '僕はたろうです。'
#             end
#         end
#     end
# end

# RSpec.describe User do
#     describe '#greet' do
#         # ローカル変数もインスタンス変数もletで定義できる　before do~endで囲まなくてもおk
#         let(:user) { User.new(params) }
#         # ここに注意！　下に説明
#         let(:params) { { name: 'たろう', age: age } }
#         context '12歳以下の場合' do
#             # before do
#                 # params.merge!(age: 12)
#             # end
#             let(:age) { 12 }
#             it 'ひらがなで答えること' do
#                 expect(user.greet).to eq 'ぼくはたろうだよ。'
#             end
#         end
#         context '13歳以上の場合' do
#             # before do
#             #     params.merge!(age: 13)
#             # end
#             let(:age) { 13 }
#             it '漢字で答えること' do
#                 expect(user.greet).to eq '僕はたろうです。'
#             end
#         end
#     end
# end

# let(:params) { { name: 'たろう' } } と同じ意味のコード
# let(:params) do
#     hash = {}
#     hash[:name] = 'たろう'
#     hash
# end

#　letは遅延評価される　＝　必要な時に呼ばれる
# expect(user.greet).to が呼ばれる => user って何だ？
# let(:user) { User.new(params) } が呼ばれる => params って何だ？
# let(:params) { { name: 'たろう', age: age } } が呼ばれる => age って何だ？
# let(:age) { 12 } （または13） が呼ばれる
# 結果として expect(User.new(name: 'たろう', age: 12).greet).to を呼んだことになる


# RSpec.describe User do
#     describe '#greet' do
#         let(:user) { User.new(name: 'たろう', age: age )}
#         # let(:user) { User.new(params) }
#         # let(:params) { { name: 'たろう', age: age } }
#         # テスト対象のオブジェクトが一つに決まっているときはsubjectにまとめられる
#         subject { user.greet }
#         context '12歳以下の場合' do
#             let(:age) { 12 }
#             # subjectが主語になって、expectがis_expectedになる
#             it { is_expected.to eq 'ぼくはたろうだよ。' }
#         end
#         context '13歳以上の場合' do
#             let(:age) { 13 }
#             it { is_expected.to eq '僕はたろうです。' }
#         end
#     end
# end

# 同じexampleが２回ずつ登場
# RSpec.describe User do
#     describe '#greet' do
#         let(:user) { User.new(name: 'たろう', age: age) }
#         subject { user.greet }

#         context '0歳の場合' do
#             let(:age) { 0 }
#             it { is_expected.to eq 'ぼくはたろうだよ。' }
#         end
#         context '12歳の場合' do
#             let(:age) { 12 }
#             it { is_expected.to eq 'ぼくはたろうだよ。' }
#         end

#         context '13歳の場合' do
#             let(:age) { 13 }
#             it { is_expected.to eq '僕はたろうです。' }
#         end
#         context '100歳の場合' do
#             let(:age) { 100 }
#             it { is_expected.to eq '僕はたろうです。' }
#         end
#     end
# end

# 同じexampleをまとめる
RSpec.describe User do
    describe '#greet' do
        let(:user) { User.new(name: 'たろう', age: age) }
        subject { user.greet }
        # shared_examplesで同じexampleをまとめられる
        shared_examples '子どものあいさつ' do
            it { is_expected.to eq 'ぼくはたろうだよ。' }
        end
        context '0歳の場合' do
            let(:age) { 0 }
            # it_behaves_likeでshared_examplesで定義したもの中から使える
            it_behaves_like '子どものあいさつ'
        end
        context '12歳の場合' do
            let(:age) { 12 }
            it_behaves_like '子どものあいさつ'
        end

        shared_examples '大人のあいさつ' do
            it { is_expected.to eq '僕はたろうです。' }
        end
        context '13歳の場合' do
            let(:age) { 13 }
            it_behaves_like '大人のあいさつ'
        end
        context '100歳の場合' do
            let(:age) { 100 }
            it_behaves_like '大人のあいさつ'
        end
    end
  end