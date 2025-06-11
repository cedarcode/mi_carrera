module CookiesHelper
  def approvable_ids_in_cookie(cookie)
    value = cookie[:approved_approvable_ids]
    value.present? ? JSON.parse(value) : nil
  end
end
