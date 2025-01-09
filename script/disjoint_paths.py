import math
import matplotlib.pyplot as plt
import networkx as nx

from networkx.algorithms.shortest_paths.weighted import dijkstra_path


def greedy_disjoint_paths(G, source_target_pairs, c=1):
    for _, _, data in G.edges(data=True):
        data["length"] = 1
        data["congestion"] = 0

    # for u, v, d in G.edges(data=True):
    #     print(f"{u=} --> {v=}, {d=}")

    I, P = [], []
    beta = math.pow(G.number_of_edges(), 1 / (c + 1))

    # print(f"{beta=}\n")

    while True:
        min_path = None
        min_length = float("inf")
        min_connected_index = None
        for i in range(len(source_target_pairs)):
            if i in I:
                continue

            source, destination = source_target_pairs[i]
            try:
                path = dijkstra_path(G, source, destination, "length")
            except Exception:
                pass
            else:
                single_lengths = [
                    G[path[i]][path[i + 1]]["length"] for i in range(len(path) - 1)
                ]
                length = sum(single_lengths)

                # print(
                #     f"{path=}, {source=}, {destination=}, {single_lengths=}, {length=}"
                # )

                if length < min_length:
                    min_path = path
                    min_length = length
                    min_connected_index = i

        if min_path is None:
            break

        # print(f"{min_path=}, {length=}, {min_connected_index=}")

        I += [min_connected_index]
        P += [min_path]

        for i in range(len(min_path) - 1):
            source = min_path[i]
            destination = min_path[i + 1]
            G[source][destination]["length"] *= beta
            G[source][destination]["congestion"] += 1

            if G[source][destination]["congestion"] == c:
                G.remove_edge(source, destination)

        # for u, v, d in G.edges(data=True):
        #     print(f"{u=} --> {v=}, {d=}")
        # print()

    return I, P


def double_fan(t=10):
    G = nx.DiGraph()

    G.add_nodes_from(["s", "t", "x", "y"])
    G.add_nodes_from(["a" + str(x) for x in range(t)])
    G.add_nodes_from(["b" + str(x) for x in range(t)])

    G.add_edges_from([("s", "a" + str(x)) for x in range(t)])
    G.add_edges_from([("a" + str(x), "x") for x in range(t)])
    G.add_edges_from([("x", "y")])
    G.add_edges_from([("y", "b" + str(x)) for x in range(t)])
    G.add_edges_from([("b" + str(x), "t") for x in range(t)])

    return G


def main():
    G = double_fan(t=10)

    # nx.draw(G, with_labels=True)
    # plt.show()

    I, P = greedy_disjoint_paths(G, 1 * [("s", "t")], c=1)
    print(f"{I=}, {P=}")

    # nx.draw(G, with_labels=True)
    # plt.show()


if __name__ == "__main__":
    main()
