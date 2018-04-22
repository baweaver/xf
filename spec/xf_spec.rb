require 'spec_helper'
require 'xf'

RSpec.describe Xf do
  describe 'PublicApi' do
    describe '#pipe' do
      it 'can be used to run a series of procs against each item of a colleciton' do
        expect(
          %w(1 2 3 4).map(&Xf.pipe(:to_i, :succ))
        ).to eq([2, 3, 4, 5])
      end

      it 'can be used against existing procs' do
        adds = -> x { -> y { x + y } }

        expect(
          %w(1 2 3 4).map(&Xf.pipe(:to_i, :succ, adds[3]))
        ).to eq([5, 6, 7, 8])
      end

      it 'will crash when given something that cannot be coerced' do
        expect { [1,2,3].map(&Xf.pipe(1)) }.to raise_error(NoMethodError)
      end
    end
  end
end
