module PostsHelper
  REPEAT_INTENTION_ICONS = {
    "yes" => ["favorite", "text-primary"],
    "undecided" => ["pending", "text-secondary"],
    "no" => ["do_not_disturb_on", "text-on-surface-variant"]
  }.freeze

  def repeat_intention_icon(post)
    REPEAT_INTENTION_ICONS.fetch(post.repeat_intention, ["favorite", "text-on-surface-variant"])
  end

  REPEAT_INTENTION_BADGE_CLASSES = {
    "yes" => "bg-secondary text-white",
    "undecided" => "bg-tertiary-container text-white",
    "no" => "bg-outline text-white"
  }.freeze

  def repeat_intention_badge_class(post)
    REPEAT_INTENTION_BADGE_CLASSES.fetch(post.repeat_intention, "bg-outline text-white")
  end

  REPEAT_INTENTION_SELECTOR_ICONS = {
    "yes" => ["sentiment_very_satisfied", "text-tertiary"],
    "undecided" => ["help", "text-secondary"],
    "no" => ["sentiment_very_dissatisfied", "text-error"]
  }.freeze

  def repeat_intention_selector_icon(value)
    REPEAT_INTENTION_SELECTOR_ICONS.fetch(value.to_s, ["help", "text-on-surface-variant"])
  end
end
