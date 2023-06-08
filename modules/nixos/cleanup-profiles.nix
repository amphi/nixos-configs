{ pkgs, ... }:
let
  script = pkgs.writeScript "delete-old-profiles" ''
    # set the directory path
    DIR="/nix/var/nix/profiles"

    # set the number of profiles to preserve
    MIN_FILES=3
    # set the age threshold in days
    AGE_THRESHOLD_DAYS=3

    # set the age threshold in seconds
    AGE_THRESHOLD=$((AGE_THRESHOLD_DAYS*24*60*60))

    # change to the target directory
    cd "$DIR"

    # get a list of all files, sorted by modification time (oldest first)
    FILES=$(find . -maxdepth 1 -name "system-*-link" -printf '%T@ %p\n' | sort -n | cut -f2- -d" ")
    NUM_FILES=$(echo "$FILES" | wc -l)

    # if there are fewer than the minimum number of files to preserve, exit
    if [ "$NUM_FILES" -le "$MIN_FILES" ]; then
        echo "No files to delete."
        exit 0
    fi

    echo "Found $NUM_FILES system profiles"

    # loop through the files, skipping the newest ones and deleting the oldest ones
    i=0
    for file in $FILES; do
        # get the file age in seconds
        age=$(($(date +%s) - $(stat -c %Y "$file")))

        # skip files newer than the age threshold
        if [ "$age" -lt "$AGE_THRESHOLD" ]; then
            continue
        fi

        echo "$file is $((age / 60 / 60 / 24 )) days old, deleting"
        # delete the file
        rm $file

        # increment the count of deleted files
        ((i++))

        # if we've deleted enough files, stop deleting
        if  (( NUM_FILES - i <= MIN_FILES )); then
            break
        fi
    done

    # print the number of deleted files
    echo "Deleted $i files."
  '';
in
{
  systemd.services.delete-old-profiles = {
    # I should probably make this timer-based, but it seems perfectly fine to run this every time I
    # reboot the laptop.
    wantedBy = [ "multi-user.target" ];
    description = "Delete old profiles so /boot doesn't run out of space";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash ${script}";
    };
  };
}

