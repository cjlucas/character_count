defmodule Counter do
  defmodule Report do
    defstruct report: []

    def report_line_count(report, _, false), do: report
    def report_line_count(report, %{num_lines: n}, true) do
      s = "Line count: #{n}"
      [s | report]
    end

    def report_word_count(report, _, false), do: report
    def report_word_count(report, %{num_words: n}, true) do
      s = "Word count: #{n}"
      [s | report]
    end

    def report_char_count(report, _, false), do: report
    def report_char_count(report, %{num_chars: n}, true) do
      s = "Character count: #{n}"
      [s | report]
    end
  end

  def run do
    {flags, fpaths, _} =
      OptionParser.parse(System.argv, switches: [
                           line: :boolean,
                           word: :boolean,
                           character: :boolean,
                           all: :boolean,
                           report: :string
                         ])

    if Enum.empty?(fpaths) do
      IO.puts :stderr, """
      Usage: mix run counter.exs <options> <infile>

      Options:
      --line - Get line count
      --word - Get word count
      --character - Get character count
      --all - Get all of the above counts
      --report <outfile> - Write report of counts to a file
      """
    else
      flags = 
        flags
        |> Enum.into(%{})
        |> Map.put_new(:line, false)
        |> Map.put_new(:word, false)
        |> Map.put_new(:character, false)
        |> Map.put_new(:all, false)

      fpath = List.first(fpaths)

      case File.open(fpath) do
        {:ok, _} ->
          info = CharacterCount.read_file(fpath)
          report = 
            []
            |> Report.report_line_count(info, flags[:line] || flags[:all])
            |> Report.report_word_count(info, flags[:word] || flags[:all])
            |> Report.report_char_count(info, flags[:character] || flags[:all])

          iodev =
          if flags[:report] do
            File.open(flags[:report], [:write])
          else
            {:ok, :stdio}
          end

          case iodev do
            {:ok, dev} ->
              Enum.each(report, fn line ->
                IO.write dev, line
                IO.write dev, "\n"
              end)
            {:error, reason} ->
              IO.puts :stderr, "Error: Could not write report to file: #{flags[:report]} #{reason}"
            end
            {:error, _} ->
              IO.puts :stderr, "Error: file could not be opened: #{fpath}"
        end
      end
  end
end

Counter.run
