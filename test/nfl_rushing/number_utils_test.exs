defmodule NFLRushing.NumberUtilsTest do
  use ExUnit.Case, async: true
  alias NFLRushing.NumberUtils

  describe "parse_compound_stat/1" do
    test "parses a string value without a touchdown" do
      assert {89, false} = NumberUtils.parse_compound_stat("89")
    end

    test "parses a string value with a touchdown" do
      assert {89, true} = NumberUtils.parse_compound_stat("89T")
    end

    test "parses an integer value" do
      assert {89, false} = NumberUtils.parse_compound_stat(89)
    end
  end

  describe "parse_float/1" do
    test "parses a string value" do
      assert 112.24 = NumberUtils.parse_float("112.24")
    end

    test "parses a complex string value" do
      assert 10112.24 = NumberUtils.parse_float("10,112.24")
    end

    test "parses a float value" do
      assert 112.24 = NumberUtils.parse_float(112.24)
    end

    test "parses an integer value" do
      assert 112.0 = NumberUtils.parse_float(112)
    end
  end

  describe "parse_integer/1" do
    test "parses a string value" do
      assert 112 = NumberUtils.parse_integer("112")
    end

    test "parses a complex string value" do
      assert 10112 = NumberUtils.parse_integer("10,112")
    end

    test "parses an integer value" do
      assert 112 = NumberUtils.parse_integer(112)
    end
  end
end
