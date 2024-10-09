# Employee Attendance Tracker with Leave and Holiday Management
Discussion: This project aimed to create a comprehensive attendance tracking system by consolidating employee attendance data with leave allowance information. The dataset included two sheets—one for daily attendance and another for leave allotments. In the attendance sheet, employees marked as "A" were absent, but some absences were due to their approved leave, while others were truly absent without leave. The leave sheet provided specific information about which employees were allowed to take leave on particular days.
The goal was to generate a final, corrected attendance sheet that reflects:

'A' for employees who were absent without an approved leave,
'L' for employees who were not present due to an approved leave, and
'P' for employees who were present.
Additionally, for Sundays, a universal 'Off' mark was to be applied for all employees, since Sunday is a designated day off.

To solve this, I leveraged advanced Excel functions such as:

VLOOKUP to match employee leave data with attendance records,
INDEX to extract specific data points,
IF to apply logical conditions for marking attendance status, and
IFERROR to handle cases where no matching leave data was found.
#### One challenge was ensuring accurate leave data for overlapping days or special holidays. By using conditional logic and validation rules, I was able to manage these exceptions seamlessly.

#### The final solution automated attendance processing, reduced manual errors, and saved significant time for HR personnel by providing a clear overview of employee attendance patterns.

