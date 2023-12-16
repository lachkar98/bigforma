import streamlit as st  
import cx_Oracle
import pandas as pd
import oracledb

def make_clickable(link):
    # Return a string with HTML anchor tag with the link
    return f'<a target="_blank" href="{link}">{link}</a>'


oracledb.defaults.fetch_lobs = False


def fetch_search_results(search_term):
    # Oracle database connection string - modify with your details
    dsn_tns = cx_Oracle.makedsn('localhost', '1521', service_name='xe')
    connection = cx_Oracle.connect(user='sys', password='*******',mode=cx_Oracle.SYSDBA, dsn=dsn_tns)

   
    cursor = connection.cursor()

    # Prepare a REF CURSOR
    ref_cursor = cursor.var(cx_Oracle.CURSOR)

    # Call the modified PL/SQL procedure
    # Call the modified PL/SQL procedure
    cursor.callproc("display_matching_lines_python", (search_term, ref_cursor))

    # Fetch the results from the REF CURSOR into a DataFrame
    result_cursor = ref_cursor.getvalue()
    results_df = pd.DataFrame(result_cursor.fetchall(), columns=[col[0] for col in result_cursor.description])
    
    

    return results_df
   


def get_database_connection():
    # Replace with your Oracle Database connection details

    dsn_tns = cx_Oracle.makedsn('localhost', '1521', service_name='xe')

    try:
        connection = cx_Oracle.connect(user='sys', password='*******',mode=cx_Oracle.SYSDBA, dsn=dsn_tns)
        return connection
    except cx_Oracle.DatabaseError as e:
        st.error(f"Error connecting to the database: {e}")
        return None


# Set the page configuration for title and favicon
def app (): 
    # Define custom colors and fonts


    primary_color = "#6C5CE7"
    background_color = "#bbbbbb"
    text_color = "#333333"
    font = "Arial"

    # Apply custom CSS styles
    st.markdown(f"""
        <style>
        [data-testid="stAppViewContainer"] > .main {{
            background: linear-gradient(45deg, #f0f0f0, #dddddd);
        }}
            body {{
                background-color: {background_color};
                font-family: {font}, sans-serif;
            }}
            .stTextInput > label, .stButton > button {{
                color: {text_color};
            }}
            .stTextInput > div > div > input {{
                color: {text_color};
                background-color: #f4f4f4; /* Background color for the input */
                border: 2px solid {primary_color};
                border-radius: 30px; /* Add rounded corners to the input */
                padding: 12px 20px; /* Add padding to the input */
                width: 100%; /* Make the input full-width */
                font-size: 18px; /* Adjust font size */
                box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.1); /* Add a subtle box shadow */
            }}
            .stButton > button {{
                border: 2px solid {primary_color};
                color: {background_color};
                background-color: {primary_color};
                border-radius: 30px; /* Add rounded corners to the button */
                padding: 12px 25px; /* Add padding to the button */
                font-size: 18px; /* Adjust font size */
            }}
            .stButton > button:hover {{
                background-color: {text_color};
                border-color: {text_color};
                color: {primary_color};
            }}
        </style>
        """, unsafe_allow_html=True)

    # Title and description at the top
    st.markdown(f'<h1 style="color:{primary_color}; text-align:center;">Digital Courses Hub</h1>', unsafe_allow_html=True)
    st.markdown("""
        LEARN FROM THE BEST ONLINE COURSES!
        
        Welcome to Digital Courses Hub, your gateway to top-quality education. Explore a curated selection of courses from industry-leading platforms such as Udemy, Coursera, and Cegos, and embark on a journey of learning and growth with the best online courses available.
    """)

    #filter_duree = filter_formateurs = filter_notes = None

    # Setup initial filters in the sidebar (with empty options)
    filter_duree = st.sidebar.multiselect('Filter by Duration:', [])
    filter_formateurs = st.sidebar.multiselect('Filter by Instructor:', [])
    filter_notes = st.sidebar.slider('Filter by Notes:', 0, 5, (0, 5))

    connection = get_database_connection()
    if connection:
        search_term = st.text_input("Search for courses", max_chars=50)
        if st.button("Search"):
            results_df = fetch_search_results(search_term)

            # Update filter options based on search results
            if not results_df.empty:
                if 'Duree' in results_df.columns:
                    unique_duree = results_df['Duree'].unique().tolist()
                    filter_duree = st.sidebar.multiselect('Filter by Duration:', unique_duree, default=unique_duree)

                if 'Formateurs' in results_df.columns:
                    unique_formateurs = results_df['Formateurs'].unique().tolist()
                    filter_formateurs = st.sidebar.multiselect('Filter by Instructor:', unique_formateurs, default=unique_formateurs)

                if 'Notes' in results_df.columns:
                    min_note = int(results_df['Notes'].min())
                    max_note = int(results_df['Notes'].max())
                    filter_notes = st.sidebar.slider('Filter by Notes:', min_value=min_note, max_value=max_note, value=(min_note, max_note))

                # Apply filters
                if filter_duree:
                    results_df = results_df[results_df['Duree'].isin(filter_duree)]

                if filter_formateurs:
                    results_df = results_df[results_df['Formateurs'].isin(filter_formateurs)]

                if 'Notes' in results_df.columns:
                    results_df = results_df[(results_df['Notes'] >= filter_notes[0]) & (results_df['Notes'] <= filter_notes[1])]

                # Make links clickable
                if 'Liens' in results_df.columns:
                    results_df['Liens'] = results_df['Liens'].apply(make_clickable)

                st.markdown(results_df.to_html(escape=False), unsafe_allow_html=True)
            else:
                st.write("No results found.")
        else:
            st.write("Enter a search term and click 'Search'.")

        # Close the database connection
        connection.close()
    else:
        st.error("Failed to connect to the database.")

# Call the app function
if __name__ == "__main__":
    app()
