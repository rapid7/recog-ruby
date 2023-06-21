# frozen_string_literal: true

module Recog
  class VerifyReporter
    attr_reader :formatter, :success_count, :warning_count, :failure_count

    def initialize(options, formatter, path = nil)
      @options = options
      @formatter = formatter
      @path = path
      reset_counts
    end

    def report(fingerprint_count)
      reset_counts
      formatter.status_message("\n#{@path}:\n") if detail? && !@path.to_s.empty?
      yield self
      summarize(fingerprint_count) unless @options.quiet
    end

    def success(text)
      @success_count += 1
      formatter.success_message("#{padding}#{text}") if detail?
    end

    def warning(text, line = nil)
      return unless @options.warnings

      @warning_count += 1
      formatter.warning_message("#{path_label(line)}#{padding}WARN: #{text}")
    end

    def failure(text, line = nil)
      @failure_count += 1
      formatter.failure_message("#{path_label(line)}#{padding}FAIL: #{text}")
    end

    def print_name(fingerprint)
      return unless detail? && fingerprint.tests.any?

      name = fingerprint.name.empty? ? '[unnamed]' : fingerprint.name
      formatter.status_message("\n#{name}")
    end

    def summarize(fingerprint_count)
      print_fingerprint_count(fingerprint_count) if detail?
      print_summary
    end

    def print_fingerprint_count(count)
      formatter.status_message("\nVerified #{count} fingerprints:")
    end

    def print_summary
      colorize_summary(summary_line)
    end

    private

    def reset_counts
      @success_count = @failure_count = @warning_count = 0
    end

    def detail?
      @options.detail
    end

    def path_label(line = nil)
      return if detail?

      line_label = line ? "#{line}:" : ''
      @path.to_s.empty? ? '' : "#{@path}:#{line_label} "
    end

    def padding
      '   ' if @options.detail
    end

    def summary_line
      "#{path_label}SUMMARY: Test completed with #{@success_count} successful, #{@warning_count} warnings, and #{@failure_count} failures"
    end

    def colorize_summary(summary)
      if @failure_count > 0
        formatter.failure_message(summary)
      elsif @warning_count > 0
        formatter.warning_message(summary)
      else
        formatter.success_message(summary)
      end
    end
  end
end
