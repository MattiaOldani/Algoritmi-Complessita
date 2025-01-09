import matplotlib.pyplot as plt
import networkx as nx
import random

from scipy.optimize import linprog


def total_price_for_vertices(G):
    prices = {x: 0 for x in G.nodes()}
    for n1, n2, data in G.edges(data=True):
        prices[n1] += data["price"]
        prices[n2] += data["price"]

    return prices


def pricing_vertex_cover(G, w):
    for _, _, data in G.edges(data=True):
        data["price"] = 0

    while True:
        total_price = total_price_for_vertices(G)

        delta_min = float("inf")
        delta_edge = None
        for u, v in G.edges():
            if total_price[u] == w[u] or total_price[v] == w[v]:
                continue

            delta = min(w[u] - total_price[u], w[v] - total_price[v])
            if delta < delta_min:
                delta_min = delta
                delta_edge = (u, v)

        if delta_edge is None:
            break

        u, v = delta_edge
        G[u][v]["price"] += delta_min

    total_price = total_price_for_vertices(G)
    return set([x for x in G.nodes() if total_price[x] == w[x]])


def rounding_vertex_cover(G, w):
    nodes = list(G.nodes())

    c = [w[x] for x in nodes]
    A = [[-1 if x == u or x == v else 0 for x in nodes] for u, v in G.edges()]
    b = [-1 for _ in G.edges()]

    xstar = linprog(c, A, b, bounds=(0, 1), integrality=0).x
    xover = [0 if v < 1 / 2 else 1 for v in xstar]

    return set([nodes[i] for i in range(len(nodes)) if xover[i] == 1])


def exact_vertex_cover(G, w):
    nodes = list(G.nodes())

    c = [w[x] for x in nodes]
    A = [[-1 if x == u or x == v else 0 for x in nodes] for u, v in G.edges()]
    b = [-1 for _ in G.edges()]

    xstar = linprog(c, A, b, bounds=(0, 1), integrality=1).x

    return set([nodes[i] for i in range(len(nodes)) if abs(xstar[i] - 1) < 1e-3])


def is_vertex_cover(G, choosen_nodes):
    for u, v in G.edges():
        if u not in choosen_nodes and v not in choosen_nodes:
            return False

    return True


def vertex_cover_cost(choosen_nodes, w):
    return sum([w[x] for x in choosen_nodes])


def main():
    G = nx.erdos_renyi_graph(100, 0.3)
    w = {x: random.randrange(1, 50) for x in G.nodes()}

    # nx.draw(G, with_labels=True)
    # plt.show()

    selected = pricing_vertex_cover(G, w)
    if is_vertex_cover(G, selected):
        cost = vertex_cover_cost(selected, w)
        print(f"Pricing Vertex Cover: {selected=}, {cost=}")
        print()

    selected = rounding_vertex_cover(G, w)
    if is_vertex_cover(G, selected):
        cost = vertex_cover_cost(selected, w)
        print(f"Rounding Vertex Cover: {selected=}, {cost=}")
        print()

    selected = exact_vertex_cover(G, w)
    if is_vertex_cover(G, selected):
        cost = vertex_cover_cost(selected, w)
        print(f"Exact Vertex Cover: {selected=}, {cost=}")


if __name__ == "__main__":
    main()
