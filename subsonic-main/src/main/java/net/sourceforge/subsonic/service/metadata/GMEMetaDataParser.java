package net.sourceforge.subsonic.service.metadata;

import net.sourceforge.subsonic.domain.MediaFile;
import org.apache.commons.io.FilenameUtils;

import java.io.File;
import java.net.URL;

/**
 * Parsers Video Game Music File Metadata
 *
 * @author Eric Fulton
 */
public class GMEMetaDataParser extends MetaDataParser {
    /**
     * Native Functions
     */
    private native void loadTrackInfo(String path);

    /**
     * SNES Track Information Fields
     */
    private int playLength; /* Length if available, else default of 150000 Milliseconds */
    private int length; /* Length if available, else -1 */
    private String gameName;
    private String trackName;
    private String systemName;
    private String authorName;
    private String copyright;
    private String comment;
    private String dumper;

    @Override
    public MetaData getRawMetaData(File file) {
        MetaData metaData = new MetaData();
        loadTrackInfo(file.getAbsolutePath());

        metaData.setAlbumName(this.gameName);
        metaData.setTitle(this.trackName);
        metaData.setGenre("Game Music");
        metaData.setArtist(this.authorName);
        metaData.setAlbumArtist(this.authorName);
        metaData.setVariableBitRate(false);
        metaData.setBitRate(1411);
        metaData.setDurationSeconds(this.playLength/1000);

        return metaData;
    }

    @Override
    public void setMetaData(MediaFile file, MetaData metaData) {/* Not Supported */}

    @Override
    public boolean isApplicable(File file) {
        if (!file.isFile()) {
            return false;
        }
        String format = FilenameUtils.getExtension(file.getName()).toLowerCase();
        return format.equals("spc");
    }

    @Override
    public boolean isEditingSupported() {
        return false;
    }

    /**
     * OS Determination
     */
    private static String OS = System.getProperty("os.name").toLowerCase();
    public static boolean isWindows() {
        return (OS.indexOf("win") >= 0);
    }
    public static boolean isMac() {
        return (OS.indexOf("mac") >= 0);
    }
    public static boolean isUnix() {
        return (OS.indexOf("nix") >= 0 || OS.indexOf("nux") >= 0 || OS.indexOf("aix") > 0 );
    }
    public static boolean isSolaris() {
        return (OS.indexOf("sunos") >= 0);
    }

    /**
     * JNI Setup
     */
    static {
        String sep = System.getProperty("file.separator");
        String baseLibsPath = System.getProperty("user.dir")+sep+"webapps"+sep+"subsonic"+sep+"libgme"+sep;
        if (isMac()) {
            baseLibsPath += "libgme.dylib";
        } else if (isUnix()) {
            baseLibsPath += "libgme.so";
        } else if (isWindows()) {
            baseLibsPath = null;
        } else if (isSolaris()) {
            baseLibsPath = null;
        } else {
            baseLibsPath = null;
        }

        // Unsupported Operating System
        if (baseLibsPath == null) {
            throw new RuntimeException("Could not find appropriate lib file for the game music library!");
        }

        System.load(baseLibsPath);
    }
}

