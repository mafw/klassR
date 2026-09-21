# Created: 2026-09-21
# AI-generated diagnostic for a future-edge update_klass issue.

# Inspect the Stavanger 2018-to-2019 lookup while future municipality-code
# changes are present in a graph targeted at 2019.

if (!requireNamespace("klassR", quietly = TRUE)) {
  stop("Install the klassR package before running this reproduction.")
}

if (!requireNamespace("igraph", quietly = TRUE)) {
  stop("Install the igraph package before running this reproduction.")
}

classification <- 131
source_code <- "1103"
source_date <- "2018-01-01"
target_date <- "2019-01-01"

graph <- klassR::klass_graph(classification, target_date)

cat("klassR version:\n")
print(utils::packageVersion("klassR"))

cat("\nGraph targeted at", target_date, ":\n")
cat("Vertices:", igraph::vcount(graph), "\n")
cat("Edges:", igraph::ecount(graph), "\n")

vertices <- igraph::as_data_frame(graph, what = "vertices")
municipality_codes <- c("1103", "1141", "1142")
municipality_vertices <- vertices[
  vertices$code %in% municipality_codes,
  c("name", "code", "label", "validFrom", "validTo"),
  drop = FALSE
]

cat("\nStavanger, Finnoy, and Rennesoy vertices:\n")
print(municipality_vertices)

edges <- igraph::as_data_frame(graph, what = "edges")
municipality_vertex_names <- municipality_vertices$name
incident_edges <- edges[
  edges$from %in% municipality_vertex_names |
    edges$to %in% municipality_vertex_names,
  ,
  drop = FALSE
]

cat("\nIncident edges, including future changes:\n")
print(incident_edges)

cat("\nOriginal graph, report = FALSE, combine = FALSE:\n")
original_result <- klassR::update_klass(
  codes = source_code,
  dates = source_date,
  date = target_date,
  classification = classification,
  graph = graph,
  output = "code",
  report = FALSE,
  combine = FALSE
)
print(original_result)

cat("\nOriginal graph, report = FALSE, combine = TRUE:\n")
original_combined_result <- klassR::update_klass(
  codes = source_code,
  dates = source_date,
  date = target_date,
  classification = classification,
  graph = graph,
  output = "code",
  report = FALSE,
  combine = TRUE
)
print(original_combined_result)

future_edge_ids <- which(
  as.character(igraph::E(graph)$changeOccurred) > target_date
)
pruned_graph <- igraph::delete_edges(graph, future_edge_ids)

cat("\nFuture edges removed:", length(future_edge_ids), "\n")
cat("Pruned graph, report = FALSE, combine = FALSE:\n")
pruned_result <- klassR::update_klass(
  codes = source_code,
  dates = source_date,
  date = target_date,
  classification = classification,
  graph = pruned_graph,
  output = "code",
  report = FALSE,
  combine = FALSE
)
print(pruned_result)

cat("\nPruned graph, report = FALSE, combine = TRUE:\n")
pruned_combined_result <- klassR::update_klass(
  codes = source_code,
  dates = source_date,
  date = target_date,
  classification = classification,
  graph = pruned_graph,
  output = "code",
  report = FALSE,
  combine = TRUE
)
print(pruned_combined_result)

cat("\nObserved comparison:\n")
cat("Original result:", original_result[[source_code]], "\n")
cat("Original result is NA:", is.na(original_result[[source_code]]), "\n")
cat("Pruned result:", pruned_result[[source_code]], "\n")

cat("\n\nLyngen case\n")

source_code <- "5424"
source_date <- "2022-01-01"
target_date <- "2025-01-01"

graph <- klassR::klass_graph(classification, target_date)
vertices <- igraph::as_data_frame(graph, what = "vertices")
lyngen_vertices <- vertices[
  vertices$code %in% c("5424", "5536"),
  c("name", "code", "label", "validFrom", "validTo"),
  drop = FALSE
]

cat("\nLyngen vertices:\n")
print(lyngen_vertices)

edges <- igraph::as_data_frame(graph, what = "edges")
lyngen_vertex_names <- lyngen_vertices$name
lyngen_edges <- edges[
  edges$from %in% lyngen_vertex_names |
    edges$to %in% lyngen_vertex_names,
  ,
  drop = FALSE
]

cat("\nLyngen incident edges, including future changes:\n")
print(lyngen_edges)

cat("\nLyngen original graph, report = FALSE, combine = FALSE:\n")
lyngen_original_result <- klassR::update_klass(
  codes = source_code,
  dates = source_date,
  date = target_date,
  classification = classification,
  graph = graph,
  output = "code",
  report = FALSE,
  combine = FALSE
)
print(lyngen_original_result)

cat("\nLyngen original graph, report = FALSE, combine = TRUE:\n")
lyngen_original_combined_result <- klassR::update_klass(
  codes = source_code,
  dates = source_date,
  date = target_date,
  classification = classification,
  graph = graph,
  output = "code",
  report = FALSE,
  combine = TRUE
)
print(lyngen_original_combined_result)

future_edge_ids <- which(
  as.character(igraph::E(graph)$changeOccurred) > target_date
)
lyngen_pruned_graph <- igraph::delete_edges(graph, future_edge_ids)

cat("\nLyngen future edges removed:", length(future_edge_ids), "\n")
cat("Lyngen pruned graph, report = FALSE, combine = FALSE:\n")
lyngen_pruned_result <- klassR::update_klass(
  codes = source_code,
  dates = source_date,
  date = target_date,
  classification = classification,
  graph = lyngen_pruned_graph,
  output = "code",
  report = FALSE,
  combine = FALSE
)
print(lyngen_pruned_result)

cat("\nLyngen pruned graph, report = FALSE, combine = TRUE:\n")
lyngen_pruned_combined_result <- klassR::update_klass(
  codes = source_code,
  dates = source_date,
  date = target_date,
  classification = classification,
  graph = lyngen_pruned_graph,
  output = "code",
  report = FALSE,
  combine = TRUE
)
print(lyngen_pruned_combined_result)

cat("\nLyngen observed comparison:\n")
cat(
  "Original result:",
  paste(lyngen_original_result[[source_code]], collapse = " -> "),
  "\n"
)
cat(
  "Pruned result:",
  paste(lyngen_pruned_result[[source_code]], collapse = " -> "),
  "\n"
)
cat(
  "Original combine = TRUE result:",
  lyngen_original_combined_result[[source_code]],
  "\n"
)
cat(
  "Pruned combine = TRUE result:",
  lyngen_pruned_combined_result[[source_code]],
  "\n"
)

cat("\n\nLyngen unchanged-code case\n")

source_code <- "5536"
source_date <- "2024-01-01"
target_date <- "2025-01-01"

graph <- klassR::klass_graph(classification, target_date)
vertices <- igraph::as_data_frame(graph, what = "vertices")
lyngen_unchanged_vertices <- vertices[
  vertices$code == source_code,
  c("name", "code", "label", "validFrom", "validTo"),
  drop = FALSE
]

cat("\nLyngen 2024-2025 vertices:\n")
print(lyngen_unchanged_vertices)

edges <- igraph::as_data_frame(graph, what = "edges")
lyngen_unchanged_vertex_names <- lyngen_unchanged_vertices$name
lyngen_unchanged_edges <- edges[
  edges$from %in% lyngen_unchanged_vertex_names |
    edges$to %in% lyngen_unchanged_vertex_names,
  ,
  drop = FALSE
]

cat("\nLyngen 2024-2025 incident edges:\n")
print(lyngen_unchanged_edges)

cat(
  "\nLyngen 2024-2025 original graph, ",
  "report = FALSE, combine = FALSE:\n",
  sep = ""
)
lyngen_unchanged_original_result <- klassR::update_klass(
  codes = source_code,
  dates = source_date,
  date = target_date,
  classification = classification,
  graph = graph,
  output = "code",
  report = FALSE,
  combine = FALSE
)
print(lyngen_unchanged_original_result)

cat(
  "\nLyngen 2024-2025 original graph, ",
  "report = FALSE, combine = TRUE:\n",
  sep = ""
)
lyngen_unchanged_original_combined_result <- klassR::update_klass(
  codes = source_code,
  dates = source_date,
  date = target_date,
  classification = classification,
  graph = graph,
  output = "code",
  report = FALSE,
  combine = TRUE
)
print(lyngen_unchanged_original_combined_result)

future_edge_ids <- which(
  as.character(igraph::E(graph)$changeOccurred) > target_date
)
lyngen_unchanged_pruned_graph <- igraph::delete_edges(
  graph,
  future_edge_ids
)

cat(
  "\nLyngen 2024-2025 future edges removed:",
  length(future_edge_ids),
  "\n"
)
cat(
  "Lyngen 2024-2025 pruned graph, ",
  "report = FALSE, combine = FALSE:\n",
  sep = ""
)
lyngen_unchanged_pruned_result <- klassR::update_klass(
  codes = source_code,
  dates = source_date,
  date = target_date,
  classification = classification,
  graph = lyngen_unchanged_pruned_graph,
  output = "code",
  report = FALSE,
  combine = FALSE
)
print(lyngen_unchanged_pruned_result)

cat(
  "\nLyngen 2024-2025 pruned graph, ",
  "report = FALSE, combine = TRUE:\n",
  sep = ""
)
lyngen_unchanged_pruned_combined_result <- klassR::update_klass(
  codes = source_code,
  dates = source_date,
  date = target_date,
  classification = classification,
  graph = lyngen_unchanged_pruned_graph,
  output = "code",
  report = FALSE,
  combine = TRUE
)
print(lyngen_unchanged_pruned_combined_result)

cat("\nLyngen 2024-2025 observed comparison:\n")
cat(
  "Original combine = FALSE result:",
  lyngen_unchanged_original_result[[source_code]],
  "\n"
)
cat(
  "Original combine = TRUE result:",
  lyngen_unchanged_original_combined_result[[source_code]],
  "\n"
)
cat(
  "Pruned combine = FALSE result:",
  lyngen_unchanged_pruned_result[[source_code]],
  "\n"
)
cat(
  "Pruned combine = TRUE result:",
  lyngen_unchanged_pruned_combined_result[[source_code]],
  "\n"
)

cat("\n\nAlesund merger case\n")

source_codes <- c("1504", "1523", "1529", "1534", "1546")
source_date <- "2018-01-01"
target_date <- "2019-01-01"

graph <- klassR::klass_graph(classification, target_date)
vertices <- igraph::as_data_frame(graph, what = "vertices")
alesund_vertices <- vertices[
  vertices$code %in% c(source_codes, "1507"),
  c("name", "code", "label", "validFrom", "validTo"),
  drop = FALSE
]

cat("\nAlesund merger vertices:\n")
print(alesund_vertices)

edges <- igraph::as_data_frame(graph, what = "edges")
alesund_vertex_names <- alesund_vertices$name
alesund_edges <- edges[
  edges$from %in% alesund_vertex_names |
    edges$to %in% alesund_vertex_names,
  ,
  drop = FALSE
]

cat("\nAlesund incident edges, including future changes:\n")
print(alesund_edges)

alesund_original_combine_false <- setNames(
  lapply(
    source_codes,
    function(code) {
      klassR::update_klass(
        codes = code,
        dates = source_date,
        date = target_date,
        classification = classification,
        graph = graph,
        output = "code",
        report = FALSE,
        combine = FALSE
      )[[code]]
    }
  ),
  source_codes
)

alesund_original_combine_true <- setNames(
  lapply(
    source_codes,
    function(code) {
      klassR::update_klass(
        codes = code,
        dates = source_date,
        date = target_date,
        classification = classification,
        graph = graph,
        output = "code",
        report = FALSE,
        combine = TRUE
      )[[code]]
    }
  ),
  source_codes
)

future_edge_ids <- which(
  as.character(igraph::E(graph)$changeOccurred) > target_date
)
alesund_pruned_graph <- igraph::delete_edges(graph, future_edge_ids)

alesund_pruned_combine_false <- setNames(
  lapply(
    source_codes,
    function(code) {
      klassR::update_klass(
        codes = code,
        dates = source_date,
        date = target_date,
        classification = classification,
        graph = alesund_pruned_graph,
        output = "code",
        report = FALSE,
        combine = FALSE
      )[[code]]
    }
  ),
  source_codes
)

alesund_pruned_combine_true <- setNames(
  lapply(
    source_codes,
    function(code) {
      klassR::update_klass(
        codes = code,
        dates = source_date,
        date = target_date,
        classification = classification,
        graph = alesund_pruned_graph,
        output = "code",
        report = FALSE,
        combine = TRUE
      )[[code]]
    }
  ),
  source_codes
)

cat("\nAlesund 2018-2019 results:\n")
print(data.frame(
  source_code = source_codes,
  original_combine_false = unname(unlist(alesund_original_combine_false)),
  original_combine_true = unname(unlist(alesund_original_combine_true)),
  pruned_combine_false = unname(unlist(alesund_pruned_combine_false)),
  pruned_combine_true = unname(unlist(alesund_pruned_combine_true)),
  row.names = NULL
))

cat(
  "\nAlesund old codes flagged as combined in the original graph:\n"
)
print(source_codes[is.na(unlist(alesund_original_combine_false))])

cat("\n\nTrondheim earlier code-change case\n")

source_code <- "1601"
source_date <- "2017-01-01"
target_date <- "2019-01-01"

graph <- klassR::klass_graph(classification, target_date)
vertices <- igraph::as_data_frame(graph, what = "vertices")
trondheim_vertices <- vertices[
  vertices$code %in% c("1601", "5001"),
  c("name", "code", "label", "validFrom", "validTo"),
  drop = FALSE
]

cat("\nTrondheim vertices:\n")
print(trondheim_vertices)

edges <- igraph::as_data_frame(graph, what = "edges")
trondheim_vertex_names <- trondheim_vertices$name
trondheim_edges <- edges[
  edges$from %in% trondheim_vertex_names |
    edges$to %in% trondheim_vertex_names,
  ,
  drop = FALSE
]

cat("\nTrondheim incident edges, including future changes:\n")
print(trondheim_edges)

cat("\nTrondheim original graph, report = FALSE, combine = FALSE:\n")
trondheim_original_result <- klassR::update_klass(
  codes = source_code,
  dates = source_date,
  date = target_date,
  classification = classification,
  graph = graph,
  output = "code",
  report = FALSE,
  combine = FALSE
)
print(trondheim_original_result)

cat("\nTrondheim original graph, report = FALSE, combine = TRUE:\n")
trondheim_original_combined_result <- klassR::update_klass(
  codes = source_code,
  dates = source_date,
  date = target_date,
  classification = classification,
  graph = graph,
  output = "code",
  report = FALSE,
  combine = TRUE
)
print(trondheim_original_combined_result)

future_edge_ids <- which(
  as.character(igraph::E(graph)$changeOccurred) > target_date
)
trondheim_pruned_graph <- igraph::delete_edges(graph, future_edge_ids)

cat("\nTrondheim future edges removed:", length(future_edge_ids), "\n")
cat("Trondheim pruned graph, report = FALSE, combine = FALSE:\n")
trondheim_pruned_result <- klassR::update_klass(
  codes = source_code,
  dates = source_date,
  date = target_date,
  classification = classification,
  graph = trondheim_pruned_graph,
  output = "code",
  report = FALSE,
  combine = FALSE
)
print(trondheim_pruned_result)

cat("\nTrondheim pruned graph, report = FALSE, combine = TRUE:\n")
trondheim_pruned_combined_result <- klassR::update_klass(
  codes = source_code,
  dates = source_date,
  date = target_date,
  classification = classification,
  graph = trondheim_pruned_graph,
  output = "code",
  report = FALSE,
  combine = TRUE
)
print(trondheim_pruned_combined_result)

cat("\nTrondheim observed comparison:\n")
cat(
  "Original combine = FALSE result:",
  trondheim_original_result[[source_code]],
  "\n"
)
cat(
  "Original combine = TRUE result:",
  trondheim_original_combined_result[[source_code]],
  "\n"
)
cat(
  "Pruned combine = FALSE result:",
  trondheim_pruned_result[[source_code]],
  "\n"
)
cat(
  "Pruned combine = TRUE result:",
  trondheim_pruned_combined_result[[source_code]],
  "\n"
)