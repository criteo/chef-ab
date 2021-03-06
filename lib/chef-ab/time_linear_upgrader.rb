require 'backports/2.0.0/array/bsearch'

module ChefAB
  class TimeLinearUpgrader < BaseUpgrader

    attr_accessor :start_time, :end_time

    def initialize(options)
      super(options)
      @start_time = options[:start_time].to_i
      @end_time = options[:end_time].to_i
      upgrade_span = @end_time - @start_time
      @hash = @hash % upgrade_span
    end

    def should_execute?(time = nil)
      time ||= current_time
      threshold    = time - start_time
      super(threshold)
    end

    def expected_activation
      (@start_time..@end_time).to_a.bsearch do |fake_time|
        should_execute?(fake_time)
      end
    end

    private

    def current_time
      Time.now.to_i
    end

  end
end
