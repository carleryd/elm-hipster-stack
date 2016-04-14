use Timex

defmodule TimeHelper do
  def currentTime do
      timestamp = Timex.format(DateTime.now, "{ISO:Extended}")
      case timestamp do
        {:ok, iso} ->
          iso
        {:error, reason} ->
          IO.inspect "schema could not be created because #{reason}"
        _other ->
          IO.inspect "unknown error while creating timestamp"
      end
  end
end
