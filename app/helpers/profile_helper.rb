module ProfileHelper
  def group_credits_class(met)
    "subject-group-credits-#{met ? "met" : "unmet"}"
  end
end
