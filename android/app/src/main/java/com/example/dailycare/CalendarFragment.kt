// CalendarFragment
import android.app.AlarmManager
import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.DatePicker
import android.widget.EditText
import android.widget.TimePicker
import androidx.core.os.bundleOf
import androidx.fragment.app.Fragment
import androidx.fragment.app.setFragmentResult
import androidx.lifecycle.ViewModelProvider
import com.example.dailycare.R
import com.example.dailycare.SharedViewModel
import com.example.dailycare.TimerFragment
import java.util.Calendar

class CalendarFragment : Fragment() {
    private lateinit var datePicker: DatePicker
    private lateinit var timePicker: TimePicker
    private lateinit var timerEditText: EditText
    private lateinit var setTimerButton: Button
    private lateinit var sharedViewModel: SharedViewModel

    // Method to set the OnTimerSetListener
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        sharedViewModel = ViewModelProvider(requireActivity()).get(SharedViewModel::class.java)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_calendar, container, false)

        // Initialize views
        datePicker = view.findViewById(R.id.datePicker)
        timePicker = view.findViewById(R.id.timePicker)
        timerEditText = view.findViewById(R.id.timerEditText)
        setTimerButton = view.findViewById(R.id.setTimerButton)

        // Set click listener for the Set Timer Button
        setTimerButton.setOnClickListener {
            // Get selected date from DatePicker
            val year = datePicker.year
            val month = datePicker.month
            val day = datePicker.dayOfMonth

            // Get selected time from TimePicker
            val hour = timePicker.hour
            val minute = timePicker.minute

            // Combine date and time to create a Calendar instance
            val calendar = Calendar.getInstance()
            calendar.set(year, month, day, hour, minute)

            // Get the timer value from the EditText
            val timerValue = timerEditText.text.toString()

            sharedViewModel.setSelectedDateTime(calendar, timerValue)


            val fragmentManager = requireActivity().supportFragmentManager
            val fragmentTransaction = fragmentManager.beginTransaction()
            val newFragment = TimerFragment()
            fragmentTransaction.replace(R.id.fragment_container, newFragment)
            //fragmentManager.popBackStack();
            fragmentTransaction.commit()
        }

        return view
    }


}

