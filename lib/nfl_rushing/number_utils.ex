defmodule NFLRushing.NumberUtils do
  @moduledoc """
  This module provides a set of functions for parsing numeric values.
  """

  @doc """
  Parses a string value representing a compound statistic into a integer and
  boolean value.

  This function expects the given value to be either an integer or a String that
  contains just an integer value or an integer value and the "T" character (
  which indicates the stat resulted in a touchdown).

  The returned value is a tuple of the form `{stat, is_touchdown}`, where `stat`
  is the integer value of the stat and `is_touchdown` is a boolean indicating if
  the stat resulted in a touchedown.
  """
  @spec parse_compound_stat(String.t() | integer()) :: {integer(), boolean()}
  def parse_compound_stat(value) when is_binary(value) do
    if String.ends_with?(value, "T") do
      value =
        value
        |> String.trim("T")
        |> parse_integer()

      {value, true}
    else
      {parse_integer(value), false}
    end
  end

  def parse_compound_stat(value) when is_integer(value), do: {value, false}

  @doc """
  Parses the given value into a floating point number.
  """
  @spec parse_float(String.t() | float() | integer()) :: float()
  def parse_float(value) when is_float(value), do: value

  def parse_float(value) when is_binary(value) do
    value
    |> String.replace(",", "")
    |> String.to_float()
  end

  def parse_float(value) when is_integer(value), do: value / 1

  @doc """
  Parses the given value into a integer.
  """
  @spec parse_integer(String.t() | integer()) :: integer()
  def parse_integer(value) when is_integer(value), do: value

  def parse_integer(value) when is_binary(value) do
    value
    |> String.replace(",", "")
    |> String.to_integer()
  end
end
