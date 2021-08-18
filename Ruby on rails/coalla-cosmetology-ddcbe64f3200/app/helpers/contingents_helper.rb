module ContingentsHelper

  def change_group_text(group_subscription)
    group_subscription.group_transfers.map do|transfer|
      transfer.change_group_order.try(:number).present? ? "#{transfer.change_group_order.number} #{format_date(transfer.change_group_order.created_on)} из группы #{transfer.old_group.try(:name).to_s}" : ''
    end.join(', ')
  end

end