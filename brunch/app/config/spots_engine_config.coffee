exports.config =
  zen : {}

  challenge :
    final_score_time_left_multiplier: 100
    time_limit                      : 60
    points_per_difference           : 100
    differences_to_find             : 20
    spot_speed_bonus_time_delta     : 3
    spot_speed_bonus_multiplier     : {1 : 1, 2 : 2, 3 : 5, 4 : 10, 5 : 50}
    clue_penalty_points             : 100
    bonus_per_unused_clue :
      0 : {time : 0, points : 0}
      2 : {time : 5, points : 500}
      3 : {time : 10, points : 2000}
      4 : {time : 15, points : 5000}
    time_penalty_per_error : {1 : 0, 2 : 2, 3 : 5}

  survival :
    final_score_clues_left_multiplier: 500
    final_score_time_left_multiplier : 100
    points_per_difference            : 100
    spot_speed_bonus_time_delta      : 3
    spot_speed_bonus_multiplier      : {1 : 1, 2 : 2, 3 : 5, 4 : 10, 5 : 50}
    bonus_per_unused_clue :
      0 : {time : 0, points : 0}
      2 : {time : 5, points : 500}
      3 : {time : 10, points : 2000}
      4 : {time : 15, points : 5000}
    time_penalty_per_error : {1 : 0, 2 : 2, 3 : 5}
    difficulty_per_item :
     1 : {time : 90, clues : 3}
     2 : {time : 85, clues : 2}
     3 : {time : 80, clues : 1}
     4 : {time : 65, clues : 3}
     5 : {time : 60, clues : 2}
     6 : {time : 55, clues : 1}
     7 : {time : 40, clues : 3}
     8 : {time : 35, clues : 2}
     9 : {time : 30, clues : 1}
     10 : {time : 25, clues : 3}
     11 : {time : 20, clues : 2}
     12 : {time : 20, clues : 1}
