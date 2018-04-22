require 'spec_helper'
require 'xf'

RSpec.describe Xf::TraceKeyValue do
  let(:path) { [:a, 1] }
  let(:trace) { Xf::TraceKeyValue.new(*path) }

  let(:target_hash) { {a: 1, b: {a: 2, c: {a: 3, d: 1}}} }

  describe '#initialize' do
    it 'can create a trace' do
      expect(trace).to be_a(Xf::TraceKeyValue)
    end
  end

  describe '#get' do
    it 'finds all values that match the target' do
      expect(trace.get.call(target_hash)).to eq([1])
    end
  end

  describe '#set' do
    it 'can set a value on any matching node without modifying the original hash' do
      expect(trace.set(3).call(target_hash)).to eq({a: 3, b: {a: 2, c: {a: 3, d: 1}}})
      expect(target_hash).to eq({a: 1, b: {a: 2, c: {a: 3, d: 1}}})
    end

    it 'can conditionally set a value using a blocks return without providing a set value' do
      odd_return = trace.set { |v| v.odd? }.call(target_hash)
      expect(odd_return).to eq({a: true, b: {a: 2, c: {a: 3, d: 1}}})

      expect(target_hash).to eq({a: 1, b: {a: 2, c: {a: 3, d: 1}}})
    end
  end

  describe '#set!' do
    it 'can mutate a value for those tough ground in issues' do
      expect(trace.set!(3).call(target_hash)).to eq({a: 3, b: {a: 2, c: {a: 3, d: 1}}})
      expect(target_hash).to eq({a: 3, b: {a: 2, c: {a: 3, d: 1}}})
    end
  end
end
