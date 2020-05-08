note
	description: "[
			A {GRAPH} whose edges are marked with data of type L.
			]"
	author: "Jimmy J. Johnson"
	license: "Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: jjj $"
	URL: 		"$URL: file:///F:/eiffel_repositories/graphs_618/trunk/graphs/interface/containers/labeled_graph.e $"
	date:		"$Date: 2012-07-05 00:31:27 -0400 (Thu, 05 Jul 2012) $"
	revision:	"$Revision: 13 $"

class
	LABELED_GRAPH [L]

inherit

	GRAPH
		redefine
			iterator,
			node_anchor,
			edge_anchor
		end

create
	default_create
	
feature -- Access

	iterator: LABELED_GRAPH_ITERATOR [L]
			-- Create a new iterator for accessing the nodes and edges in Current.
			-- Anchor for the graph iterators.
		do
			create Result.make (Current)
		end

feature -- Element change

	connect_nodes_labeled (a_node, a_other_node: like node_anchor; a_label: L)
			-- Make sure graph contains the two nodes and connect them
			-- by creating an edge with `a_label'.  The new edge can be
			-- accessed through `last_new_edge'.
		require
			node_exists: a_node /= Void
			other_exists: a_other_node /= Void
			label_exists: a_label /= Void
			is_connection_allowed: is_connection_allowed (a_node, a_other_node)
		do
			connect_nodes (a_node, a_other_node)
			last_new_edge.set_label (a_label)
		ensure
			node_inserted: has_node (a_node)
			other_node_inserted: has_node (a_other_node)
			edge_inserted: has_edge (last_new_edge)
			proper_from_connection_made: last_new_edge.originates_at (a_node)
			proper_to_connection_made: last_new_edge.terminates_at (a_other_node)
			label_was_set: last_new_edge.label = a_label
		end

	connect_nodes_labeled_directed (a_node, a_other_node: like node_anchor; a_label: L)
			-- Make sure graph contains the two nodes and connect them
			-- by creating a directed edge with `a_label'.  The new edge can be
			-- accessed through `last_new_edge'.
		require
			node_exists: a_node /= Void
			other_exists: a_other_node /= Void
			label_exists: a_label /= Void
			is_connection_allowed: is_connection_allowed (a_node, a_other_node)
		do
			connect_nodes_labeled (a_node, a_other_node, a_label)
			last_new_edge.set_directed
		ensure
			node_inserted: has_node (a_node)
			other_node_inserted: has_node (a_other_node)
			edge_inserted: has_edge (last_new_edge)
			proper_from_connection_made: last_new_edge.originates_at (a_node)
			proper_to_connection_made: last_new_edge.terminates_at (a_other_node)
			label_was_set: last_new_edge.label = a_label
			new_edge_is_directed: last_new_edge.is_directed
		end

feature -- Query

	has (a_label: L): BOOLEAN
			-- Does Current have an edge containing `a_label'?
			-- If True, the edge can be obtained from `last_found_edge'
		require
			label_exists: a_label /= Void
		local
			i: INTEGER
			e: like edge_anchor
		do
			from i := 1
			until i > edges.count
			loop
				e := edges.i_th (i)
				if object_comparison then
					if equal (e.label, a_label) then
						Result := True
						found_edge_ref.set_edge (e)
					end
				else
					if a_label = e.label then
						Result := True
						found_edge_ref.set_edge (e)
					end
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	last_found_edge: like edge_anchor
			-- The last edge found with a call to `has'
		require
			found_edge_ref_has_edge: found_edge_ref.edge /= Void
		do
			check attached {like edge_anchor} found_edge_ref.edge as e then
				Result := e
			end
		end

	found_edge_ref: EDGE_REF
			-- Holds the edge that was found by the last call to `has'
		once
			create Result
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: LABELED_NODE [L]
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	edge_anchor: LABELED_EDGE [L]
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end


end
