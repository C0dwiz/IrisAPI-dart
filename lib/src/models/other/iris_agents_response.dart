class IrisAgentsResponse {
  final List<int> agents;

  IrisAgentsResponse({required this.agents});

  factory IrisAgentsResponse.fromJson(List<dynamic> json) {
    return IrisAgentsResponse(
      agents: json.cast<int>().toList(),
    );
  }
}
