# 黑曜赤金长剑_平面型四视图

created_at: 2026-06-22
workflow_source: D:\Work\Note\yanzo\81_WorkFlow 工作流\Roblox\Tripo多视图工作流\README.md
weapon_type: 平面型长剑
source_shape_lock: D:\SVN\Project_Analysis_Package\Roblox 武器模型制作工作流\generated_views\slate_long_sword_2026-06-22_blue_steel_variant_four_views
candidate_dir: D:\Work\Note\yanzo\81_WorkFlow 工作流\Roblox\Tripo多视图工作流\输出内容\_imagegen_candidates\黑曜赤金长剑_2026-06-22

## Current State

- completed_steps:
  - workflow_read
  - previous_four_view_shape_lock_archived
  - output_folder_created
- current_step: front_skin_candidate_waiting_user_approval
- next_step: user_front_approval
- last_verification_result: front_candidate_01_passed_internal_visual_check_pending_user_approval

## Design Lock

- Keep the exact same weapon class: long vertical Roblox low-poly fantasy sword.
- Keep the same silhouette and proportions: tall narrow blade, compact angular shoulder guard, slim black segmented upper grip, rounded faceted pommel, long central blade channel, faceted pointed lower tip.
- Do not change shape, guard size, blade width, handle length, pommel shape, side profile rule, or overall height ratio.
- Change only material and color style.

## New Skin Direction

- style name: 黑曜赤金
- blade outer planes: dark obsidian / blackened steel
- bevels and guard accents: aged gold / brass
- center inlay: ember red / orange-red glow, painted texture not VFX
- grip: deep black leather bands
- material feel: Roblox low-poly hand-painted metal, simple viewport lighting

## View Gates

- front: candidate_pass_pending_user_approval
- back: pending
- left: pending
- right: pending

## Candidate Outputs

- front_candidate_01: D:\Work\Note\yanzo\81_WorkFlow 工作流\Roblox\Tripo多视图工作流\输出内容\_imagegen_candidates\黑曜赤金长剑_2026-06-22\front_candidate_01.png

## Rules

- Generate and confirm front first.
- After front approval, use it as the only design lock for back / left / right.
- For side views, this is a flat weapon type: true 90-degree thin side profile.
- If left side passes and the sword is symmetrical, mirror it for right side.
- This workflow creates Tripo / 3D AI reference images only; no Roblox FBX / GLB packaging.
