# frozen_string_literal: true

class FirstTryBadge < Badge

  def test_id
    rule_value
  end

  def check_condition(test_passage)
    return false unless test_passage.passed
    return false unless test_passage.test_id == test_id

    test_passage.user.test_passages.where(passed: true, test_id: test_id).count == 1
  end

  def description
    I18n.t(:desc, scope: localization_scope, test: Test.find(test_id).title)
  end
end
