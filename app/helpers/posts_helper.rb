module PostsHelper
  REPEAT_INTENTION_ICONS = {
    "yes" => ["favorite", "text-primary"],
    "undecided" => ["pending", "text-secondary"],
    "no" => ["do_not_disturb_on", "text-on-surface-variant"]
  }.freeze

  def repeat_intention_icon(post)
    REPEAT_INTENTION_ICONS.fetch(post.repeat_intention, ["favorite", "text-on-surface-variant"])
  end
end
