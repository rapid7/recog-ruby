require 'json'

module Recog
class MatchReporter
  attr_reader :formatter
  attr_reader :line_count, :match_count, :fail_count

  def initialize(options, formatter)
    @options = options
    @formatter = formatter
    reset_counts
  end

  def report
    reset_counts
    yield self
    summarize unless @options.quiet
  end

  def stop?
    return false unless @options.fail_fast
    @fail_count >= @options.stop_after
  end

  def increment_line_count
    @line_count += 1
  end

  def match(match_data)
    @match_count += 1
    if @options.json_format
      # remove data field from all matches and promote to a top-level field
      data_field = match_data[0]["data"]
      match_data.each { |h| h.delete("data") }
      new_object = {
        'data' => data_field,
      }

      if @options.multi_match
        new_object['matches'] = match_data
      else
        new_object['match'] = match_data[0]
      end
      msg = new_object.to_json
    else
      match_prefix = match_data.size > 1 ? 'MATCHES' : 'MATCH'
      msg = "#{match_prefix}: #{match_data.map(&:inspect).join(',')}"
    end
    formatter.success_message("#{msg}")
  end

  def failure(text)
    @fail_count += 1
    if @options.json_format
      new_object = {
        'data' => text,
        'match_failure' => true
      }
      if @options.multi_match
        new_object['matches'] = nil
      else
        new_object['match'] = nil
      end
      msg = new_object.to_json
    else
      msg = "FAIL: #{text}"
    end
    formatter.failure_message("#{msg}")
  end

  def print_summary
    colorize_summary(summary_line)
  end

  private

  def reset_counts
    @line_count = @match_count = @fail_count = 0
  end

  def detail?
    @options.detail
  end

  def summarize
    if detail?
      print_lines_processed
      print_summary
    end
  end

  def print_lines_processed
    formatter.status_message("\nProcessed #{line_count} lines")
  end

  def summary_line
    summary = "SUMMARY: "
    summary << "#{match_count} matches"
    summary << " and #{fail_count} failures"
    summary
  end

  def colorize_summary(summary)
    if @fail_count > 0
      formatter.failure_message(summary)
    else
      formatter.success_message(summary)
    end
  end
end
end
