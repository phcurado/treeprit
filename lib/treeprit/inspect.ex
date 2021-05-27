defimpl Inspect, for: Treeprit do
  def inspect(%Treeprit{} = val, _opts) do
    """
    #Treeprit{
      results: #{inspect(val.results)},
      errors: #{inspect(val.errors)},
      successful_operations: #{val.successful_operations},
      failed_operations: #{val.failed_operations},
      skipped_operations: #{val.skipped_operations},
      total_operations: #{val.total_operations}
    }
    """
  end
end
