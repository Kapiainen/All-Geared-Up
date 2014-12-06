package skyprocstarter;

import java.awt.Color;
import java.awt.Font;
import java.net.URL;
import java.util.ArrayList;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import lev.gui.LSaveFile;
import skyproc.*;
import skyproc.genenums.Gender;
import skyproc.genenums.Perspective;
import skyproc.gui.SPMainMenuPanel;
import skyproc.gui.SUM;
import skyproc.gui.SUMGUI;
import skyprocstarter.YourSaveFile.Settings;

/**
 *
 * @author Your Name Here
 */
public class SkyProcStarter implements SUM {

    /*
     * The important functions to change are:
     * - getStandardMenu(), where you set up the GUI
     * - runChangesToPatch(), where you put all the processing code and add records to the output patch.
     */

    /*
     * The types of records you want your patcher to import. Change this to
     * customize the import to what you need.
     */
    GRUP_TYPE[] importRequests = new GRUP_TYPE[]{
	GRUP_TYPE.WEAP,
        GRUP_TYPE.ARMA,
        GRUP_TYPE.ARMO,
        GRUP_TYPE.FLST,
        GRUP_TYPE.QUST
    };
    public static String myPatchName = "All Geared Up";
    public static String authorName = "MrJack";
    public static String version = "1.0";
    public static String welcomeText = "Welcome to the Walking Armory patcher for All Geared Up.";
    public static String descriptionToShowInSUM = "All Geared Up - Walking Armory patcher.";
    public static Color headerColor = new Color(66, 181, 184);  // Teal
    public static Color settingsColor = new Color(72, 179, 58);  // Green
    public static Font settingsFont = new Font("Serif", Font.BOLD, 15);
    public static SkyProcSave save = new YourSaveFile();

    // Do not write the bulk of your program here
    // Instead, write your patch changes in the "runChangesToPatch" function
    // at the bottom
    public static void main(String[] args) {
	try {
	    SPGlobal.createGlobalLog();
	    SUMGUI.open(new SkyProcStarter(), args);
	} catch (Exception e) {
	    // If a major error happens, print it everywhere and display a message box.
	    System.err.println(e.toString());
	    SPGlobal.logException(e);
	    JOptionPane.showMessageDialog(null, "There was an exception thrown during program execution: '" + e + "'  Check the debug logs or contact the author.");
	    SPGlobal.closeDebug();
	}
    }

    @Override
    public String getName() {
	return myPatchName;
    }

    // This function labels any record types that you "multiply".
    // For example, if you took all the armors in a mod list and made 3 copies,
    // you would put ARMO here.
    // This is to help monitor/prevent issues where multiple SkyProc patchers
    // multiply the same record type to yeild a huge number of records.
    @Override
    public GRUP_TYPE[] dangerousRecordReport() {
	// None
	return new GRUP_TYPE[0];
    }

    @Override
    public GRUP_TYPE[] importRequests() {
	return importRequests;
    }

    @Override
    public boolean importAtStart() {
	return false;
    }

    @Override
    public boolean hasStandardMenu() {
	return true;
    }

    // This is where you add panels to the main menu.
    // First create custom panel classes (as shown by YourFirstSettingsPanel),
    // Then add them here.
    @Override
    public SPMainMenuPanel getStandardMenu() {
	SPMainMenuPanel settingsMenu = new SPMainMenuPanel(getHeaderColor());

	settingsMenu.setWelcomePanel(new WelcomePanel(settingsMenu));
	settingsMenu.addMenu(new OtherSettingsPanel(settingsMenu), false, save, Settings.OTHER_SETTINGS);

	return settingsMenu;
    }

    // Usually false unless you want to make your own GUI
    @Override
    public boolean hasCustomMenu() {
	return false;
    }

    @Override
    public JFrame openCustomMenu() {
	throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public boolean hasLogo() {
	return false;
    }

    @Override
    public URL getLogo() {
	throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public boolean hasSave() {
	return true;
    }

    @Override
    public LSaveFile getSave() {
	return save;
    }

    @Override
    public String getVersion() {
	return version;
    }

    @Override
    public ModListing getListing() {
	return new ModListing(getName(), false);
    }

    @Override
    public Mod getExportPatch() {
	Mod out = new Mod(getListing());
	out.setAuthor(authorName);
	return out;
    }

    @Override
    public Color getHeaderColor() {
	return headerColor;
    }

    // Add any custom checks to determine if a patch is needed.
    // On Automatic Variants, this function would check if any new packages were
    // added or removed.
    @Override
    public boolean needsPatching() {
	return false;
    }

    // This function runs when the program opens to "set things up"
    // It runs right after the save file is loaded, and before the GUI is displayed
    @Override
    public void onStart() throws Exception {
    }

    // This function runs right as the program is about to close.
    @Override
    public void onExit(boolean patchWasGenerated) throws Exception {
    }

    // Add any mods that you REQUIRE to be present in order to patch.
    @Override
    public ArrayList<ModListing> requiredMods() {
	return new ArrayList<>(0);
    }

    @Override
    public String description() {
	return descriptionToShowInSUM;
    }

    // This is where you should write the bulk of your code.
    // Write the changes you would like to make to the patch,
    // but DO NOT export it.  Exporting is handled internally.
    @Override
    public void runChangesToPatch() throws Exception {

	Mod patch = SPGlobal.getGlobalPatch();

	Mod merger = new Mod(getName() + "Merger", false);
	merger.addAsOverrides(SPGlobal.getDB());

	// Write your changes to the patch here.
        // FormLists
        FLST daggerBase = (FLST) merger.getMajor("_AGU_FORMLIST_DaggerBase", GRUP_TYPE.FLST);
        FLST daggerWeapon = (FLST) merger.getMajor("_AGU_FORMLIST_DaggerWeapon", GRUP_TYPE.FLST);
        FLST daggerSheath = (FLST) merger.getMajor("_AGU_FORMLIST_DaggerSheath", GRUP_TYPE.FLST);
        FLST waraxeBase = (FLST) merger.getMajor("_AGU_FORMLIST_WarAxeBase", GRUP_TYPE.FLST);
        FLST waraxeWeapon = (FLST) merger.getMajor("_AGU_FORMLIST_WarAxeWeapon", GRUP_TYPE.FLST);
        FLST waraxeSheath = (FLST) merger.getMajor("_AGU_FORMLIST_WarAxeSheath", GRUP_TYPE.FLST);
        FLST maceBase = (FLST) merger.getMajor("_AGU_FORMLIST_MaceBase", GRUP_TYPE.FLST);
        FLST maceWeapon = (FLST) merger.getMajor("_AGU_FORMLIST_MaceWeapon", GRUP_TYPE.FLST);
        FLST maceSheath = (FLST) merger.getMajor("_AGU_FORMLIST_MaceSheath", GRUP_TYPE.FLST);
        FLST swordBase = (FLST) merger.getMajor("_AGU_FORMLIST_SwordBase", GRUP_TYPE.FLST);
        FLST swordWeapon = (FLST) merger.getMajor("_AGU_FORMLIST_SwordWeapon", GRUP_TYPE.FLST);
        FLST swordSheath = (FLST) merger.getMajor("_AGU_FORMLIST_SwordSheath", GRUP_TYPE.FLST);
        FLST staffBase = (FLST) merger.getMajor("_AGU_FORMLIST_StaffBase", GRUP_TYPE.FLST);
        FLST staffLeftBack = (FLST) merger.getMajor("_AGU_FORMLIST_StaffLeftWeapon", GRUP_TYPE.FLST);
        FLST staffRightBack = (FLST) merger.getMajor("_AGU_FORMLIST_StaffRightWeapon", GRUP_TYPE.FLST);
        FLST shieldBase = (FLST) merger.getMajor("_AGU_FORMLIST_ShieldBase", GRUP_TYPE.FLST);
        FLST shieldBack = (FLST) merger.getMajor("_AGU_FORMLIST_ShieldBack", GRUP_TYPE.FLST);
        FLST arrowBase = (FLST) merger.getMajor("_AGU_FORMLIST_ArrowBase", GRUP_TYPE.FLST);
        FLST arrowBack = (FLST) merger.getMajor("_AGU_FORMLIST_ArrowBack", GRUP_TYPE.FLST);
        FLST boltBase = (FLST) merger.getMajor("_AGU_FORMLIST_BoltBase", GRUP_TYPE.FLST);
        FLST boltBack = (FLST) merger.getMajor("_AGU_FORMLIST_BoltBack", GRUP_TYPE.FLST);
        // Template variables
        ARMA armaBase = (ARMA) merger.getMajor("_AGU_ARMA_Template", GRUP_TYPE.ARMA);
        ARMO armoBase = (ARMO) merger.getMajor("_AGU_ARMO_Template", GRUP_TYPE.ARMO);
        ARMO bipedNode53 = (ARMO) merger.getMajor("_AGU_ARMOR_Biped53", GRUP_TYPE.ARMO);
        ARMO bipedNode54 = (ARMO) merger.getMajor("_AGU_ARMOR_Biped54", GRUP_TYPE.ARMO);
        ARMO bipedNode55 = (ARMO) merger.getMajor("_AGU_ARMOR_Biped55", GRUP_TYPE.ARMO);
        ARMO bipedNode56 = (ARMO) merger.getMajor("_AGU_ARMOR_Biped56", GRUP_TYPE.ARMO);
        ARMO bipedNode57 = (ARMO) merger.getMajor("_AGU_ARMOR_Biped57", GRUP_TYPE.ARMO);
        ARMO bipedNode58 = (ARMO) merger.getMajor("_AGU_ARMOR_Biped58", GRUP_TYPE.ARMO);
        ARMO bipedNode59 = (ARMO) merger.getMajor("_AGU_ARMOR_Biped59", GRUP_TYPE.ARMO);
        ARMO bipedNode60 = (ARMO) merger.getMajor("_AGU_ARMOR_Biped60", GRUP_TYPE.ARMO);

        // Biped nodes
        FormID bipedNode = null;
        FormID bipedNodeDagger = bipedNode53.getEquipSet();
        FormID bipedNodeMace = bipedNode54.getEquipSet();
        FormID bipedNodeSword = bipedNode55.getEquipSet();
        FormID bipedNodeStaffLeft = bipedNode56.getEquipSet();
        FormID bipedNodeStaffRight = bipedNode57.getEquipSet();
        FormID bipedNodeWarAxe = bipedNode58.getEquipSet();
        FormID bipedNodeShield = bipedNode59.getEquipSet();
        FormID bipedNodeAmmo = bipedNode60.getEquipSet();
        ARMA tempArmaWeapon = armaBase;
        ARMA tempArmaSheath = armaBase;
        ARMO tempArmoWeapon = armoBase;
        ARMO tempArmoSheath = armoBase;
        // Set the EDID prefixes and suffixes to be used for armors
        String sArmaPrefix = "_AGU_ARMA_";
        String sArmoPrefix = "_AGU_ARMO_";
        String sWeaponSuffix = "_Weapon";
        String sSheathSuffix = "_Sheath";
        String sBackSuffix = "_Back";
        String sBackModelSuffix = "OnBack.nif";
        String sWeaponModelSuffix = "Left.nif";
        String sSheathModelSuffix = "Sheath.nif";
        String sRightModelSuffix = "Right.nif";
        
        ArrayList<FormID> racesPlayable = null;
        
        // Cycle through all races and add them to a FormID list that is added to armors as Additional races
        for (RACE allRaces : merger.getRaces()){
            if (allRaces.get(RACE.RACEFlags.Playable) == true){
                racesPlayable.add(allRaces.getForm());
            }
        }
        
        // Process weapons
        for(WEAP allWeapons : merger.getWeapons()){
            WEAP.WeaponType wepType = allWeapons.getWeaponType();
            if (wepType.equals(WEAP.WeaponType.Dagger) || wepType.equals(WEAP.WeaponType.OneHAxe) || wepType.equals(WEAP.WeaponType.OneHBlunt) || wepType.equals(WEAP.WeaponType.OneHSword)){
                // Set the biped node(s) to use in the armors that are to be generated
                switch(wepType){
                case Dagger:
                        bipedNode = bipedNodeDagger;
                        break;
                case OneHAxe:
                        // bipedNode = bipedNodeWarAxe;
                        break;
                case OneHBlunt:
                        // bipedNode = bipedNodeMace;
                        break;
                case OneHSword:
                        // bipedNode = bipedNodeSword;
                        break;
                }
                String sModelPath = allWeapons.getModelFilename();
                sModelPath.replace(".nif", "");
                // Weapon armor
                String sArmaNameWeapon = sArmaPrefix + allWeapons.getEDID() + sWeaponSuffix;
                tempArmaWeapon = (ARMA) patch.makeCopy(armaBase, sArmaNameWeapon);
                tempArmaWeapon.setModelPath((sModelPath + sWeaponModelSuffix), Gender.MALE, Perspective.THIRD_PERSON);
                tempArmaWeapon.setModelPath((sModelPath + sWeaponModelSuffix), Gender.FEMALE, Perspective.THIRD_PERSON);
                // Add playable races
                for (int i = 0; i < racesPlayable.size(); i++){
                    tempArmaWeapon.addAdditionalRace(racesPlayable.get(i));
                }
                String sArmoNameWeapon = sArmoPrefix + allWeapons.getEDID() + sWeaponSuffix;
                tempArmoWeapon = (ARMO) patch.makeCopy(armoBase, sArmoNameWeapon);
                tempArmoWeapon.addArmature(tempArmaWeapon.getForm());
                tempArmoWeapon.setEquipSlot(bipedNode);
                // Sheath armor
                String sArmaNameSheath = sArmaPrefix + allWeapons.getEDID() + sSheathSuffix;
                tempArmaSheath = (ARMA) patch.makeCopy(armaBase, sArmaNameSheath);
                tempArmaSheath.setModelPath((sModelPath + sSheathModelSuffix), Gender.MALE, Perspective.THIRD_PERSON);
                tempArmaSheath.setModelPath((sModelPath + sSheathModelSuffix), Gender.FEMALE, Perspective.THIRD_PERSON);
                // Add playable races
                for (int i = 0; i < racesPlayable.size(); i++){
                    tempArmaSheath.addAdditionalRace(racesPlayable.get(i));
                }
                String sArmoNameSheath = sArmoPrefix + allWeapons.getEDID() + sSheathSuffix;
                tempArmoSheath = (ARMO) patch.makeCopy(armoBase, sArmoNameSheath);
                tempArmoSheath.addArmature(tempArmaSheath.getForm());
                tempArmoSheath.setEquipSlot(bipedNode);
            } else if (wepType.equals(WEAP.WeaponType.Staff)){
                // Generate two sets of armors, one for the left and one for the right hand staff
                String sModelPath = allWeapons.getModelFilename();
                sModelPath.replace(".nif", "");
                String sArmaNameWeapon = sArmaPrefix + allWeapons.getEDID() + sBackSuffix + "_Left";
                tempArmaWeapon = (ARMA) patch.makeCopy(armaBase, sArmaNameWeapon);
                tempArmaWeapon.setModelPath((sModelPath + sWeaponModelSuffix), Gender.MALE, Perspective.THIRD_PERSON);
                tempArmaWeapon.setModelPath((sModelPath + sWeaponModelSuffix), Gender.FEMALE, Perspective.THIRD_PERSON);
                // Add playable races
                for (int i = 0; i < racesPlayable.size(); i++){
                    tempArmaWeapon.addAdditionalRace(racesPlayable.get(i));
                }
                String sArmoNameWeapon = sArmoPrefix + allWeapons.getEDID() + sBackSuffix + "_Left";
                tempArmoWeapon = (ARMO) patch.makeCopy(armoBase, sArmoNameWeapon);
                tempArmoWeapon.addArmature(tempArmaWeapon.getForm());
                tempArmoWeapon.setEquipSlot(bipedNodeStaffLeft);
                
                String sArmaNameSheath = sArmaPrefix + allWeapons.getEDID() + sBackSuffix + "_Right";
                tempArmaSheath = (ARMA) patch.makeCopy(armaBase, sArmaNameSheath);
                tempArmaSheath.setModelPath((sModelPath + sRightModelSuffix), Gender.MALE, Perspective.THIRD_PERSON);
                tempArmaSheath.setModelPath((sModelPath + sRightModelSuffix), Gender.FEMALE, Perspective.THIRD_PERSON);
                // Add playable races
                for (int i = 0; i < racesPlayable.size(); i++){
                    tempArmaSheath.addAdditionalRace(racesPlayable.get(i));
                }
                String sArmoNameSheath = sArmoPrefix + allWeapons.getEDID() + sBackSuffix + "_Right";
                tempArmoSheath = (ARMO) patch.makeCopy(armoBase, sArmoNameSheath);
                tempArmoSheath.addArmature(tempArmaSheath.getForm());
                tempArmoSheath.setEquipSlot(bipedNodeStaffRight);
            }
            // Add weapon and generated armors to FormLists
            switch(wepType){
            case Dagger:
                    daggerBase.addFormEntry(allWeapons.getForm());
                    daggerWeapon.addFormEntry(tempArmoWeapon.getForm());
                    daggerSheath.addFormEntry(tempArmoSheath.getForm());
                    break;
            case OneHAxe:
                    waraxeBase.addFormEntry(allWeapons.getForm());
                    waraxeWeapon.addFormEntry(tempArmoWeapon.getForm());
                    waraxeSheath.addFormEntry(tempArmoSheath.getForm());
                    break;
            case OneHBlunt:
                    maceBase.addFormEntry(allWeapons.getForm());
                    maceWeapon.addFormEntry(tempArmoWeapon.getForm());
                    maceSheath.addFormEntry(tempArmoSheath.getForm());
                    break;
            case OneHSword:
                    swordBase.addFormEntry(allWeapons.getForm());
                    swordWeapon.addFormEntry(tempArmoWeapon.getForm());
                    swordSheath.addFormEntry(tempArmoSheath.getForm());
                    break;
            case Staff:
                    staffBase.addFormEntry(allWeapons.getForm());
                    staffLeftBack.addFormEntry(tempArmoWeapon.getForm());
                    staffRightBack.addFormEntry(tempArmoSheath.getForm());
                    break;
            }
        }
        // Modify shield dummy
        
        // Process shields
        for (ARMO allShields : merger.getArmors()){
            if (allShields.getBashImpactData() != null){
                // Create armor
                ArrayList<FormID> shieldArmatures = allShields.getArmatures();
                ARMA shieldArmature = (ARMA) merger.getMajor(shieldArmatures.get(0), GRUP_TYPE.ARMA);
                String sModelPath = shieldArmature.getModelPath(Gender.MALE, Perspective.THIRD_PERSON);
                sModelPath.replace(".nif", sBackModelSuffix);
                String sArmaNameWeapon = sArmaPrefix + allShields.getEDID() + sBackSuffix;
                tempArmaWeapon = (ARMA) patch.makeCopy(armaBase, sArmaNameWeapon);
                tempArmaWeapon.setModelPath(sModelPath, Gender.MALE, Perspective.THIRD_PERSON);
                tempArmaWeapon.setModelPath(sModelPath, Gender.FEMALE, Perspective.THIRD_PERSON);
                // Add playable races
                for (int i = 0; i < racesPlayable.size(); i++){
                    tempArmaWeapon.addAdditionalRace(racesPlayable.get(i));
                }
                String sArmoNameWeapon = sArmoPrefix + allShields.getEDID() + sBackSuffix;
                tempArmoWeapon = (ARMO) patch.makeCopy(armoBase, sArmoNameWeapon);
                tempArmoWeapon.addArmature(tempArmaWeapon.getForm());
                tempArmoWeapon.setEquipSlot(bipedNodeShield);
                
                // Add to correct FormList
                shieldBase.addFormEntry(allShields.getForm());
                shieldBack.addFormEntry(tempArmoWeapon.getForm());
            }
        }
        // Process ammos
        for (AMMO allAmmos : merger.getAmmo()){
            if (allAmmos.get(AMMO.AMMOFlag.NonPlayable) == false){
                // Create armor
                String sModelPath = allAmmos.getModel();
                String sArmaName = sArmaPrefix + allAmmos.getEDID() + sBackSuffix;
                tempArmaWeapon = (ARMA) patch.makeCopy(armaBase, sArmaName);
                tempArmaWeapon.setModelPath(sModelPath, Gender.MALE, Perspective.THIRD_PERSON);
                tempArmaWeapon.setModelPath(sModelPath, Gender.FEMALE, Perspective.THIRD_PERSON);
                // Add playable races
                for (int i = 0; i < racesPlayable.size(); i++){
                    tempArmaWeapon.addAdditionalRace(racesPlayable.get(i));
                }
                String sArmoName = sArmoPrefix + allAmmos.getEDID() + sBackSuffix;
                tempArmoWeapon = (ARMO) patch.makeCopy(armoBase, sArmoName);
                tempArmoWeapon.addArmature(tempArmaWeapon.getForm());
                tempArmoWeapon.setEquipSlot(bipedNodeAmmo);
                // Add to correct FormList
                if (allAmmos.get(AMMO.AMMOFlag.NonBolt) == true){
                    arrowBase.addFormEntry(allAmmos.getForm());
                    arrowBack.addFormEntry(tempArmoWeapon.getForm());
                } else {
                    boltBase.addFormEntry(allAmmos.getForm());
                    boltBack.addFormEntry(tempArmoWeapon.getForm());
                }
            }
        }
    }

}
