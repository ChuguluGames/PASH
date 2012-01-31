exports.engine_config =
  zen : {}

  challenge :
    final_score_time_left_multiplier: 100
    time_limit                      : 60
    points_per_spot                 : 100
    spot_speed_bonus_time_delta     : 3
    soot_speed_bonus_multiplier     : {1 : 1, 2 : 2, 3 : 5, 4 : 10, 5 : 50}
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
    points_per_spot                  : 100
    spot_speed_bonus_time_delta      : 3
    soot_speed_bonus_multiplier      : {1 : 1, 2 : 2, 3 : 5, 4 : 10, 5 : 50}
    bonus_per_unused_clue :
      0 : {time : 0, points : 0}
      2 : {time : 5, points : 500}
      3 : {time : 10, points : 2000}
      4 : {time : 15, points : 5000}
    time_penalty_per_error : {1 : 0, 2 : 2, 3 : 5}
    difficulty_per_item :
     1 : {time_limit : 90, clue_limit : 3}
     2 : {time_limit : 85, clue_limit : 2}
     3 : {time_limit : 80, clue_limit : 1}
     4 : {time_limit : 65, clue_limit : 3}
     5 : {time_limit : 60, clue_limit : 2}
     6 : {time_limit : 55, clue_limit : 1}
     7 : {time_limit : 40, clue_limit : 3}
     8 : {time_limit : 35, clue_limit : 2}
     9 : {time_limit : 30, clue_limit : 1}
     10 : {time_limit : 25, clue_limit : 3}
     11 : {time_limit : 20, clue_limit : 2}
     12 : {time_limit : 20, clue_limit : 1}
