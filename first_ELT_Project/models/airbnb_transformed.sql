with source as (
    select * from public.raw_airbnb_data

),

cleaned as (
    select
        name,
        cast("host_id" as bigint) as host_id,
        coalesce(cast("host_identity_verified" as varchar(25)), 'unconfirmed') as is_host_verified ,-- No need to COALESCE again
        cast("host_name" as varchar(25)) as host_name,
        cast("neighbourhood_group" as varchar(50)) as neighborhood_group,
        cast(neighbourhood as varchar(100)) as neighborhood,
        cast(lat as numeric(9,6)) as latitude,
        cast(long as numeric(9,6)) as longitude, -- Renamed
        coalesce(instant_bookable, false) as is_instant_bookable,  -- Replaced NULL with false (boolean column)
        cast(cancellation_policy as varchar(50)) as cancellation_policy,
        cast("room_type" as varchar(50)) as room_type,
        cast(cast("construction_year" as numeric )as integer) as construction_year,
        cast(replace(replace(price, ',', ''), '$', '') as INTEGER) as price,
        cast(coalesce(replace(replace("service_fee", ',', ''), '$', ''), '0') as INTEGER) as service_fee,
        case
            when cast("minimum_nights" as integer ) <0 then 1
            else coalesce(cast("minimum_nights" as integer), 1) -- Replaced NULL with 1
        end as minimum_nights,
        coalesce(cast("number_of_reviews" as integer), 0) as review_count,  -- Replaced NULL with 0
        coalesce(cast("review_rate_number" as INTEGER ) ,0) as review_rating,  -- Replaced NULL with 0
        coalesce(cast("calculated_host_listings_count" as integer), 1) as host_listings_count,  -- Replaced NULL with 1
        case
            when cast("availability_365"  as integer ) < 0 then 1
            when cast("availability_365"  as integer )  > 365 then 365
            else coalesce(cast("availability_365"  as integer ) , 1)
        end as availability_365,
        regexp_replace(coalesce(house_rules, 'No rules'), '^[^a-zA-Z]+', '') as house_rules -- Symbols at the Beginning removed and null values replaced
    from source
    where 
        name is not null
        and price is not null
        and cancellation_policy is not null
        and "neighbourhood_group" is not null
        and neighbourhood is not null
        and "room_type" is not null
        and "host_name" is not null
        and "construction_year" is not null
        and "host_id" is not null
        and lat is not null
        and long is not null
)

select * from cleaned
