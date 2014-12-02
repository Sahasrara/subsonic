#include "gme.h"
#include <jni.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

void handle_error( const char* str );
void convert(const char*, const char *);

/**
 * Globals
 */
long sample_rate = 44100; /* number of samples per second */
int track = 0; /* index of track to play (0 = first) */

void
Java_net_sourceforge_subsonic_service_metadata_GMEMetaDataParser_loadTrackInfo( JNIEnv* env, jobject callingObject, jstring filePath )
{
	/* Grab File Path */
	const char *file_path = (*env)->GetStringUTFChars(env, filePath, 0);

	/* Load Emulator */
	Music_Emu* emu;
	handle_error( gme_open_file( file_path, &emu, sample_rate ) );

	/* Get Track Info */
	gme_info_t* track_info = NULL;
	handle_error( gme_track_info( emu, &track_info, track ) );

	/* Get Class Information */
	jclass thisClass = (*env)->GetObjectClass(env, callingObject);

	/* Return Track Play Length */
	jfieldID fid_track_play_length = (*env)->GetFieldID(env, thisClass, "playLength", "I");
	(*env)->SetIntField(env, callingObject, fid_track_play_length, track_info->play_length);

	/* Return Track Length */
	jfieldID fid_track_length = (*env)->GetFieldID(env, thisClass, "length", "I");
	(*env)->SetIntField(env, callingObject, fid_track_length, track_info->length);

	/* Return Track Name */
	jfieldID fid_track_name = (*env)->GetFieldID(env, thisClass, "trackName", "Ljava/lang/String;");
	jstring track_name = (*env)->NewStringUTF(env, track_info->song);
	(*env)->SetObjectField(env, callingObject, fid_track_name, track_name);

	/* Return Game Name */
	jfieldID fid_game_name = (*env)->GetFieldID(env, thisClass, "gameName", "Ljava/lang/String;");
	jstring game_name = (*env)->NewStringUTF(env, track_info->game);
	(*env)->SetObjectField(env, callingObject, fid_game_name, game_name);

	/* Return System Name */
	jfieldID fid_system_name = (*env)->GetFieldID(env, thisClass, "systemName", "Ljava/lang/String;");
	jstring system_name = (*env)->NewStringUTF(env, track_info->system);
	(*env)->SetObjectField(env, callingObject, fid_system_name, system_name);

	/* Return Author Name */
	jfieldID fid_author_name = (*env)->GetFieldID(env, thisClass, "authorName", "Ljava/lang/String;");
	jstring author_name = (*env)->NewStringUTF(env, track_info->author);
	(*env)->SetObjectField(env, callingObject, fid_author_name, author_name);

	/* Return Copyright */
	jfieldID fid_copyright = (*env)->GetFieldID(env, thisClass, "copyright", "Ljava/lang/String;");
	jstring copyright = (*env)->NewStringUTF(env, track_info->copyright);
	(*env)->SetObjectField(env, callingObject, fid_copyright, copyright);

	/* Return Comment */
	jfieldID fid_comment = (*env)->GetFieldID(env, thisClass, "comment", "Ljava/lang/String;");
	jstring comment = (*env)->NewStringUTF(env, track_info->comment);
	(*env)->SetObjectField(env, callingObject, fid_comment, comment);

	/* Return Dumper */
	jfieldID fid_dumper = (*env)->GetFieldID(env, thisClass, "dumper", "Ljava/lang/String;");
	jstring dumper = (*env)->NewStringUTF(env, track_info->dumper);
	(*env)->SetObjectField(env, callingObject, fid_dumper, dumper);

	/* Cleanup */
	(*env)->ReleaseStringUTFChars(env, filePath, file_path);
	gme_free_info( track_info );
	gme_delete( emu );
}

/**
 * Error Handling
 */
void handle_error( const char* str )
{
  if ( str )
  {
    printf( "Error: %s\n", str ); getchar();
    exit( EXIT_FAILURE );
  }
}
