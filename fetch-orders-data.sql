select a."LocationId",
	EXTRACT(YEAR FROM to_timestamp(a."Details" ->> 'FirstSendTime', 'YYYY-MM-DD HH24:MI:SS')) AS order_year,
	EXTRACT(MONTH FROM to_timestamp(a."Details" ->> 'FirstSendTime', 'YYYY-MM-DD HH24:MI:SS')) AS order_month,
	EXTRACT(DAY FROM to_timestamp(a."Details" ->> 'FirstSendTime', 'YYYY-MM-DD HH24:MI:SS')) AS order_date,
	EXTRACT(HOUR FROM to_timestamp(a."Details" ->> 'FirstSendTime', 'YYYY-MM-DD HH24:MI:SS')) AS order_hour,
	EXTRACT(MIN FROM to_timestamp(a."Details" ->> 'FirstSendTime', 'YYYY-MM-DD HH24:MI:SS')) AS order_min,
	EXTRACT(SECOND FROM to_timestamp(a."Details" ->> 'FirstSendTime', 'YYYY-MM-DD HH24:MI:SS')) AS order_sec,
	a."Details" -> 'NetSales' OrderSize, 
	jsonb_array_length(a."Details" -> 'Items') ItemsCount,
	(
		select count(*) 
		from "Orders" b
		where b."Details" -> 'FirstSendTime' <= a."Details" -> 'FirstSendTime'
			and  
				(
					b."Details"->'IsClosed' is null or
					b."Details" -> 'CloseTime' >= a."Details" -> 'CloseTime'
				)
			and b."Details"->'FutureOrder'->'CancelledTime' is null
			and a."SourceOrderId" != b."SourceOrderId"
	) PendingOrdersCount,
	(
		select coalesce(sum(cast(b."Details" -> 'NetSales' as decimal)), 0)
		from "Orders" b
		where b."Details" -> 'FirstSendTime' <= a."Details" -> 'FirstSendTime'
			and  
				(
					b."Details"->'IsClosed' is null or
					b."Details" -> 'CloseTime' >= a."Details" -> 'CloseTime'
				)
			and b."Details"->'FutureOrder'->'CancelledTime' is null
			and a."SourceOrderId" != b."SourceOrderId"
	) PendingOrdersSize,
	(
		select coalesce(sum(jsonb_array_length(b."Details" -> 'Items')), 0)
		from "Orders" b
		where b."Details" -> 'FirstSendTime' <= a."Details" -> 'FirstSendTime'
			and  
				(
					b."Details"->'IsClosed' is null or
					b."Details" -> 'CloseTime' >= a."Details" -> 'CloseTime'
				)
			and b."Details"->'FutureOrder'->'CancelledTime' is null
			and a."SourceOrderId" != b."SourceOrderId"
	) PendingOrderItems,
	to_timestamp(a."Details" ->> 'CloseTime', 'YYYY-MM-DD HH24:MI:SS') - 
			to_timestamp(a."Details" ->> 'FirstSendTime', 'YYYY-MM-DD HH24:MI:SS') bt,
	EXTRACT
	(
		EPOCH FROM 
		(
			to_timestamp(a."Details" ->> 'CloseTime', 'YYYY-MM-DD HH24:MI:SS') - 
			to_timestamp(a."Details" ->> 'FirstSendTime', 'YYYY-MM-DD HH24:MI:SS')
		)
	) BumpTime
from "Orders" a
where a."Details"->'IsClosed' is not null
	and a."Details"->'IsClosed' = 'true'
	and a."Details"->'FutureOrder'->'CancelledTime' is null
	and a."Details" -> 'NetSales' is not null;