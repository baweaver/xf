require 'spec_helper'
require 'xf'

RSpec.describe Xf::Scope do
  let(:path) { [:a, :b, :c] }
  let(:scope) { Xf::Scope.new(path) }

  let(:target_hash) { {a: {b: {c: 1}}} }

  describe '#initialize' do
    it 'can create a scope' do
      expect(scope).to be_a(Xf::Scope)
    end
  end

  describe '#get' do
    it 'can get a value out of a hash' do
      expect(scope.get.call(target_hash)).to eq(1)
    end

    it 'can get and transform a value from a hash' do
      expect(scope.get { |v| v * 20 }.call(target_hash)).to eq(20)
    end

    context 'When given a value that\'s not a hash' do
      class FHash
        def initialize(v) @v = v end
        def [](k)         @v[k]  end
      end

      it 'will use a diving method instead of dig' do
        expect(scope.get.call(FHash.new(target_hash))).to eq(1)
      end
    end
  end

  describe '#set' do
    it 'can set a value without modifying the original hash' do
      expect(scope.set(3).call(target_hash)).to eq({a: {b: {c: 3}}})
      expect(target_hash).to eq({a: {b: {c: 1}}})
    end

    it 'can conditionally set a value using a blocks return without providing a set value' do
      odd_return = scope.set { |v| v.odd? }.call(target_hash)
      expect(odd_return).to eq({a: {b: {c: true}}})

      expect(target_hash).to eq({a: {b: {c: 1}}})
    end
  end

  describe '#set!' do
    it 'can mutate a value for those tough ground in issues' do
      expect(scope.set!(3).call(target_hash)).to eq({a: {b: {c: 3}}})
      expect(target_hash).to eq({a: {b: {c: 3}}})

      odd_return = scope.set! { |v| v.odd? }.call(target_hash)
      expect(odd_return).to eq({a: {b: {c: true}}})

      expect(target_hash).to eq({a: {b: {c: true}}})
    end
  end
end
