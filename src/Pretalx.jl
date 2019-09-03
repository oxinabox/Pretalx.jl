module Pretalx

using HTTP
using JSON2

const pretalx_token = "Token fa4ea0f04cf13c4555ad6aa5bc5009b1b5fb1121e"
const pretalx_base = "https://pretalx.com/api/events/juliacon2019/"

function get_all_raw(endpoint; pretlax_base=pretalx_base, pretalx_token=pretalx_token)
    endpoint = pretlax_base * endpoint
    results = Vector{NamedTuple}()
    while true
        # GOLDPLATE: This would be better done with asyncs
        resp = HTTP.get(endpoint, ["Authorization"=>pretalx_token])
        raw = JSON2.read(String(resp.body))

        append!(results, raw.results)
        raw.next === nothing && return results
        endpoint = raw.next
    end
end

get_all_submissions_raw(;kwargs...) = get_all_raw("submissions"; kwargs...)
get_all_speakers_raw(;kwargs...) = get_all_raw("speakers"; kwargs...)

function get_all_submissions(
        allowed_state = state -> state == "confirmed" || state=="accepted" ;
        include_raw=false, ## set this to add the raw data as well
        kwargs...
)
    submissions = get_all_submissions_raw(; kwargs...)

    viable_submissions = Vector{NamedTuple}()
    for sub in submissions
        if !allowed_state(sub.state)
            continue
        end

        submission_type = sub.submission_type isa String ? sub.submission_type : sub.submission_type.en
        speakers = getproperty.(sub.speakers, :name)
        shortsub = (
            state = sub.state,
            code=sub.code,
            title=sub.title,
            submission_type=submission_type,
            abstract = sub.abstract,
            speakers = speakers,
        )
        if include_raw
            shortsub =(shortsub..., raw=sub)
        end
        push!(viable_submissions, shortsub)
    end
    return viable_submissions
end

end # module
