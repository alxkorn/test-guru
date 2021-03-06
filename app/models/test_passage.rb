# frozen_string_literal: true

class TestPassage < ApplicationRecord
  PERCENTAGE_SACLE = 100
  PASSING_SCORE = 85
  MAX_PROGRESS = 100
  TIME_MARGIN = 0
  belongs_to :user
  belongs_to :test
  belongs_to :current_question, class_name: 'Question', optional: true

  before_validation :before_validation_set_question, on: %i[create update]

  def completed?
    current_question.nil?
  end

  def passed_by_score?
    correct_percentage >= PASSING_SCORE
  end

  def current_question_index
    total_questions - test.questions.where('id > ?', current_question.try(:id)).count
  end

  def total_questions
    test.questions.count
  end

  def progress
    return MAX_PROGRESS if completed?

    (PERCENTAGE_SACLE * (current_question_index - 1) / total_questions).to_i
  end

  def time_left
    (created_at + test.time_limit.minutes - Time.now).to_i
  end

  def time_limit_exceeded?
    return false if test.time_limit.nil?

    time_left <= TIME_MARGIN
  end

  def accept!(answer_ids)
    if time_limit_exceeded?
      self.passed = false
      self.current_question = test.questions.order(:id).last
    else
      self.correct_questions += 1 if correct_answer?(answer_ids)
      self.passed = passed_by_score?
    end
    save!
  end

  def correct_percentage
    PERCENTAGE_SACLE * correct_questions / test.questions.count
  end

  # def terminate
  #   logger.info('Entered Termination!')
  #   self.current_question = test.questions.order(:id).last
  #   self.passed = false
  #   save!
  # end

  private

  def before_validation_set_question
    self.current_question = next_question
  end

  def correct_answer?(answer_ids)
    correct_answers_count = correct_answers.count
    (correct_answers_count == correct_answers.where(id: answer_ids).count) &&
      correct_answers_count == answer_ids.count
  end

  def correct_answers
    current_question.answers.correct
  end

  def next_question
    test.questions.order(:id).where('id > ?', current_question.try(:id) || 0).first
  end
end
