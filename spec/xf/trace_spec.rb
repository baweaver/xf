require 'spec_helper'
require 'xf'

RSpec.describe Xf::Trace do
  let(:path) { :a }
  let(:trace) { Xf::Trace.new(path) }

  let(:target_hash) { {a: 1, b: {a: 2, c: {a: 3}}} }

  describe '#initialize' do
    it 'can create a trace' do
      expect(trace).to be_a(Xf::Trace)
    end
  end

  describe '#get' do
    it 'finds all values that match the target' do
      expect(trace.get.call(target_hash)).to eq([1, 2, 3])
    end

    it 'can also transform the found values' do
      expect(trace.get { |h, k, v| v + 10 }.call(target_hash)).to eq([11, 12, 13])
    end
  end

  describe '#set' do
    it 'can set a value on any matching node without modifying the original hash' do
      expect(trace.set(3).call(target_hash)).to eq({a: 3, b: {a: 3, c: {a: 3}}})
      expect(target_hash).to eq({a: 1, b: {a: 2, c: {a: 3}}})
    end

    it 'can conditionally set a value using a blocks return without providing a set value' do
      odd_return = trace.set { |v| v.odd? }.call(target_hash)
      expect(odd_return).to eq({a: true, b: {a: false, c: {a: true}}})

      expect(target_hash).to eq({a: 1, b: {a: 2, c: {a: 3}}})
    end
  end

  describe '#set!' do
    it 'can mutate a value for those tough ground in issues' do
      expect(trace.set!(3).call(target_hash)).to eq({a: 3, b: {a: 3, c: {a: 3}}})
      expect(target_hash).to eq({a: 3, b: {a: 3, c: {a: 3}}})

      odd_return = trace.set! { |v| v.odd? }.call(target_hash)
      expect(odd_return).to eq({a: true, b: {a: true, c: {a: true}}})

      expect(target_hash).to eq({a: true, b: {a: true, c: {a: true}}})
    end
  end
end
