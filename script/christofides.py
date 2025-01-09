import math
import matplotlib.pyplot as plt
import networkx as nx
import random


def generate_points(n=10, maxcoord=100):
    return [
        (random.randint(0, maxcoord), random.randint(0, maxcoord)) for _ in range(n)
    ]


def dist(p, q):
    return math.sqrt((p[0] - q[0]) ** 2 + (p[1] - q[1]) ** 2)


def plot_points(points, col2segments={}):
    maxx = max([p[0] for p in points])
    maxy = max([p[1] for p in points])

    plt.rcParams["figure.figsize"] = [maxx + 10, maxy + 10]
    plt.rcParams["figure.autolayout"] = True
    plt.xlim(-5, maxx + 5)
    plt.ylim(-5, maxy + 5)
    plt.grid()

    for p in points:
        plt.plot(
            p[0],
            p[1],
            marker="o",
            markersize=10,
            markeredgecolor="red",
            markerfacecolor="green",
        )

    for col, segments in col2segments.items():
        for segment in segments:
            p = points[segment[0]]
            q = points[segment[1]]
            plt.plot([p[0], q[0]], [p[1], q[1]], color=col, linestyle="dashed")

    plt.show()


def points2clique(points):
    G = nx.Graph()

    n = len(points)
    for i in range(n):
        for j in range(i + 1, n):
            G.add_edge(i, j, weight=dist(points[i], points[j]))

    # nx.draw(G)
    # plt.show()

    return G


def eulerian2hamiltonian(ec):
    ec_path = [e[0] for e in ec]

    hc_path = []
    for v in ec_path:
        if v not in hc_path:
            hc_path += [v]
    hc_path += [ec_path[0]]

    return [(hc_path[i], hc_path[i + 1]) for i in range(len(hc_path) - 1)]


def christofides(G):
    T = nx.minimum_spanning_tree(G)
    D = [x for x in G.nodes() if T.degree[x] % 2 == 1]
    M = nx.min_weight_matching(G.subgraph(D))

    H = nx.MultiGraph()
    for e in T.edges():
        H.add_edge(e[0], e[1])
    for e in M:
        H.add_edge(e[0], e[1])

    ec = list(nx.eulerian_circuit(H, 0))
    hc = eulerian2hamiltonian(ec)

    # print(f"Albero ricoprente minimo: {T.edges()}")
    # print(f"Vertici con grado dispari: {D}")
    # print(f"Matching perfetto di peso minimo: {M}")
    # print(f"Lati del multigrafo H: {H.edges()}")
    # print(f"Circuito euleriano: {ec}")
    # print(f"Circuito hamiltoniano: {hc}")

    return (T.edges(), M, hc)


def main():
    points = generate_points()

    G = points2clique(points)

    T, M, hc = christofides(G)

    plot_points(points, {"green": T})
    plot_points(points, {"red": M})
    plot_points(points, {"blue": hc})


if __name__ == "__main__":
    main()
